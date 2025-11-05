function New-DummyJWT {
    [CmdletBinding()]
    [OutputType([System.String])]

    Param(
        [Parameter(Mandatory = $false)]
        [System.Collections.Hashtable] $Header = @{
            alg = "RS256"
            typ = "JWT"
        },

        [Parameter(Mandatory = $false)]
        [String] $Aud = "https://graph.microsoft.com",

        [Parameter(Mandatory = $false)]
        [String] $Iss = "https://sts.windows.net/00000000-0000-0000-0000-000000000000/",

        [Parameter(Mandatory = $false)]
        [String] $Sub = "00000000-0000-0000-0000-000000000000",

        [Parameter(Mandatory = $false)]
        [String] $Jti = [Guid]::NewGuid().ToString(),

        [Parameter(Mandatory = $false)]
        [Int] $Nbf = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds(),

        [Parameter(Mandatory = $false)]
        [Int] $Exp = [DateTimeOffset]::UtcNow.AddMinutes(60).ToUnixTimeSeconds(),

        [Parameter(Mandatory = $false)]
        [Int] $Iat = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds(),
        
        [Parameter(Mandatory = $false)]
        [System.Collections.Hashtable] $OtherClaims = @{}
    )

    Process {
        $payload = @{
            aud = $Aud
            iss = $Iss
            sub = $Sub
            jti = $Jti
            nbf = $Nbf
            exp = $Exp
            iat = $Iat
        }

        if($PSCmdlet.MyInvocation.BoundParameters.ContainsKey('OtherClaims') -and $OtherClaims.Count -gt 0) {
            $OtherClaims.GetEnumerator() | ForEach-Object {
                $payload[$_.Key] = $_.Value
            }
        }

        $headerJson = ($Header | ConvertTo-Json -Compress).ToString()
        $payloadJson = ($payload | ConvertTo-Json -Compress).ToString()

        $headerEncoded = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($headerJson)).TrimEnd('=').Replace('+', '-').Replace('/', '_')
        $payloadEncoded = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($payloadJson)).TrimEnd('=').Replace('+', '-').Replace('/', '_')

        Write-Verbose "Generated Dummy JWT with payload: $payloadJson"
        return "$headerEncoded.$payloadEncoded.DUMMYSIGNATURE"
    }
}