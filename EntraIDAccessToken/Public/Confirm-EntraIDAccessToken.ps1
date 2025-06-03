<#
.SYNOPSIS
Verifies that a provided token matches certain criteria

.EXAMPLE
Confirm-EntraIDAccessToken

#>
function Confirm-EntraIDAccessToken {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $false)]
        [String] $Tid = $null,

        [Parameter(Mandatory = $false)]
        [String] $Aud = $null,

        [Parameter(Mandatory = $false)]
        [String] $Iss = $null,

        [Parameter(Mandatory = $false)]
        [ValidateSet("user","app")]
        [String] $Idtyp = $null,

        [Parameter(Mandatory = $false)]
        [String] $Idp = $null,

        [Parameter(Mandatory = $false)]
        [String] $Sub = $null,

        [Parameter(Mandatory = $false)]
        [String] $Appid = $null,

        [Parameter(Mandatory = $false)]
        [String] $Oid = $null,

        [Parameter(Mandatory = $false)]
        [String[]] $Scopes = $null,

        [Parameter(Mandatory = $false)]
        [String[]] $Wids = $null,

        [Parameter(Mandatory = $false)]
        [System.Collections.Hashtable] $OtherClaims = $null,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String] $AccessToken
    )

    Process {
        # Remove "bearer " prefix if it exists
        if($AccessToken -like "bearer *") {
            Write-Debug "Removing 'bearer ' prefix from the input object"
            $AccessToken = $AccessToken.Substring(7).Trim()
        }

        # Extract payload from the JWT token
        $Payload = $AccessToken | Get-EntraIDAccessTokenPayload -ErrorAction SilentlyContinue

        if(!$Payload) {
            Write-Error "Failed to decode the access token payload. Ensure the token is valid and properly formatted."
            return
        }
        $AllMatch = $true


        if($Payload.iss -notmatch "^https://sts\.windows\.net/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/$") {
            Write-Error "The 'iss' claim in the token does not match the expected format for Microsoft Entra ID."
            return
        }

        # $DiscoveryUrl = $Payload.iss.TrimEnd("/") + "/.well-known/openid-configuration"
        # Invoke-RestMethod -Uri $DiscoveryUrl -Method Get -ErrorAction Stop 
        # $JwksUrl = "https://login.windows.net/common/discovery/keys"

        $JwksUrl = $Payload.iss.TrimEnd("/") + "/discovery/v2.0/keys"
        if($Payload.appid) {
            $JwksUrl += "?appid=" + $Payload.appid
        }
        Write-Debug "Using JWKS URL: $JwksUrl"

        # Get the JWKS from the cache or fetch it if not cached
        if(($Script:ConfirmEntraIDAccessTokenJWKSCache[$JwksUrl].CacheExpiration ?? [DateTime]::MinValue) -lt (Get-Date)) {
            Write-Debug "Fetching JWKS from $JwksUrl"
            try {
                $Jwks = Invoke-RestMethod -Uri $JwksUrl -Method Get -ErrorAction Continue
                $Script:ConfirmEntraIDAccessTokenJWKSCache[$JwksUrl] = @{
                    Keys           = $Jwks.keys
                    CacheExpiration = (Get-Date).AddHours(8) # Cache for 8 hours
                }
            } catch {
                Write-Error "Failed to fetch JWKS from $($JwksUrl): $_"
                return
            }
        } else {
            Write-Debug "Using cached JWKS for $JwksUrl"
        }

        # Extract the header from the JWT token
        $headerjson = $AccessToken.Split(".")[0]
        $headerjson = $headerjson.PadRight($headerjson.Length + (4 - ($headerjson.Length % 4)), "=").Replace("====", "")
        try {
            $header = ConvertFrom-Json -InputObject ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($headerjson)))
        } catch {
            Write-Error "Failed to decode the JWT header: $_"
            return
        }

        # Validate that the 'kid' claim is present in the header, and that the JWKS contains a key with the same 'kid'
        if(!$header.kid) {
            Write-Error "JWT header does not contain 'kid' claim"
            return
        }
        $matchingKey = $Script:ConfirmEntraIDAccessTokenJWKSCache[$JwksUrl].Keys | Where-Object kid -eq $header.kid
        if(!$matchingKey) {
            Write-Error "No matching key found in JWKS for kid '$($header.kid)'"
            return
        } else {
            Write-Debug "Found matching key in JWKS for kid '$($header.kid)'"
        }

        # Validate the matching key
        if (($null -eq $matchingKey.kty) -or ($null -eq $matchingKey.n) -or ($null -eq $matchingKey.e)) {
            Write-Error "Matching key in JWKS is missing required properties (kty, n, e)"
            return
        }

        # Validate the kty is RSA
        if ($matchingKey.kty -ne "RSA") {
            Write-Error "Matching key in JWKS is not of type 'RSA', found '$($matchingKey.kty)'"
            return
        }

        # Validate signature - inspired by https://github.com/anthonyg-1/PSJsonWebToken/blob/main/PSJsonWebToken/PrivateFunctions/Test-JwtJwkSignature.ps1
        $ToSign = $AccessToken.Substring(0, $AccessToken.LastIndexOf("."))
        #$ToSign += "="

        # $ToSign = "{0}.{1}" -f $AccessToken.Split(".")[0].PadRight($AccessToken.Split(".")[0].Length + (4 - ($AccessToken.Split(".")[0].Length % 4)), "=").Replace("====", ""), $AccessToken.Split(".")[1].PadRight($AccessToken.Split(".")[1].Length + (4 - ($AccessToken.Split(".")[1].Length % 4)), "=").Replace("====", "")
        $Signature = $AccessToken.Split(".")[2] | ConvertFrom-Base64UrlEncodedString -ByteArray
        if (-not $Signature) {
            Write-Error "Failed to decode the JWT signature"
            return
        }

        # $publicKey = [System.Security.Cryptography.RSACryptoServiceProvider]::new()
        $publicKey = [System.Security.Cryptography.RSA]::Create()
        try {
            $rsaParams = [System.Security.Cryptography.RSAParameters]::new()
            $rsaParams.Modulus = $matchingKey.n | ConvertFrom-Base64UrlEncodedString -ByteArray
            $rsaParams.Exponent = $matchingKey.e | ConvertFrom-Base64UrlEncodedString -ByteArray
            $publicKey.ImportParameters($rsaParams)

            $hasher = [System.Security.Cryptography.HashAlgorithm]::Create('sha256')
            $hash = $hasher.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($ToSign))
            # $l = "-----BEGIN CERTIFICATE-----`n$($matchingKey.x5c)`n-----END CERTIFICATE-----"

            [byte[]]$HeaderAndPayloadBytes = [System.Text.Encoding]::UTF8.GetBytes($ToSign)


            $SignatureVerification = $publicKey.VerifyHash($hash, $Signature, [System.Security.Cryptography.HashAlgorithmName]::SHA256, [System.Security.Cryptography.RSASignaturePadding]::Pkcs1)
            Write-Host "Signature verification result: $SignatureVerification"

            $SignatureVerification = $publicKey.VerifyData($HeaderAndPayloadBytes, $Signature, [System.Security.Cryptography.HashAlgorithmName]::SHA256 , [System.Security.Cryptography.RSASignaturePadding]::Pkcs1)
            Write-Host "Signature verification result: $SignatureVerification"
        }
        catch {
            $SignatureVerification = $false
        }
        finally {
            $publicKey.Dispose()
        }

        if(!$SignatureVerification) {
            Write-Error "Signature verification failed for the JWT token"
            return
        }

        # Validate that the nbf and exp claims are present and valid
        if ($Payload.nbf -and $Payload.exp) {
            $CurrentTime = [DateTimeOffset]::Now.ToUnixTimeSeconds()
            if ($Payload.nbf -gt $CurrentTime) {
                Write-Error "Token is not yet valid (nbf: $($Payload.nbf))"
                return
            }
            if ($Payload.exp -lt $CurrentTime) {
                Write-Error "Token has expired (exp: $($Payload.exp))"
                return
            }
        } else {
            Write-Error "Token does not contain nbf or exp claims"
            return
        }

        # TODO: Validate that the InputObject is a valid access token, signed by Microsoft Entra ID, and that it is not expired.

        # Check tid only if the tid parameter is provided
        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey("tid") -and $Payload.tid -ne $Tid) {
            Write-Verbose "tid does not match: expected '$Tid', got '$($Payload.tid)'"
            $AllMatch = $false
        }

        # Check aud only if the aud parameter is provided
        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey("aud") -and $Payload.aud -ne $Aud) {
            Write-Verbose "aud does not match: expected '$Aud', got '$($Payload.aud)'"
            $AllMatch = $false
        }

        # Check iss only if the iss parameter is provided
        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey("iss") -and $Payload.iss -ne $Iss) {
            Write-Verbose "iss does not match: expected '$Iss', got '$($Payload.iss)'"
            $AllMatch = $false
        }

        # Check idp only if the idp parameter is provided
        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey("idp") -and $Payload.idp -ne $Idp) {
            Write-Verbose "idp does not match: expected '$Idp', got '$($Payload.idp)'"
            $AllMatch = $false
        }

        # Check sub only if the sub parameter is provided
        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey("sub") -and $Payload.sub -ne $Sub) {
            Write-Verbose "sub does not match: expected '$Sub', got '$($Payload.sub)'"
            $AllMatch = $false
        }

        # Check idtyp only if the idtyp parameter is provided
        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey("idtyp") -and $Payload.idtyp -ne $Idtyp) {
            Write-Verbose "idtyp does not match: expected '$Idtyp', got '$($Payload.idtyp)'"
            $AllMatch = $false
        }

        # Check appid only if the appid parameter is provided
        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey("appid") -and $Payload.appid -ne $Appid) {
            Write-Verbose "appid does not match: expected '$Appid', got '$($Payload.appid)'"
            $AllMatch = $false
        }

        # Check oid only if the oid parameter is provided
        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey("oid") -and $Payload.oid -ne $Oid) {
            Write-Verbose "oid does not match: expected '$Oid', got '$($Payload.oid)'"
            $AllMatch = $false
        }

        # Check scopes only if the scopes parameter is provided
        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey("scopes")) {
            $scpSplit = $Payload.scp -split ' ' | ForEach-Object { $_.Trim() }
            foreach ($Scope in $Scopes) {
                if ($scpSplit -notcontains $Scope) {
                    Write-Verbose "Scope '$Scope' not found in token"
                    $AllMatch = $false
                }
            }
        }

        # Check wids only if the wids parameter is provided
        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey("wids")) {
            foreach ($Wid in $Wids) {
                if ($Payload.wids -notcontains $Wid) {
                    Write-Verbose "Wid '$Wid' not found in token"
                    $AllMatch = $false
                }
            }
        }

        # Check other claims only if the OtherClaims parameter is provided
        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey("OtherClaims")) {
            foreach ($Key in $OtherClaims.Keys) {
                if (-not $Payload.ContainsKey($Key)) {
                    Write-Verbose "Claim '$Key' not found in token"
                    $AllMatch = $false
                }
                elseif ($Payload[$Key] -ne $OtherClaims[$Key]) {
                    Write-Verbose "Claim '$Key' does not match: expected '$($OtherClaims[$Key])', got '$($Payload[$Key])'"
                    $AllMatch = $false
                }
            }
        }

        if ($AllMatch) {
            return $AccessToken
        }
        else {
            Write-Verbose "Token does not match the specified criteria"
        }
    }
}