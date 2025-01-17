<#
.SYNOPSIS
Gets an access token from Entra ID for the configured profile

.EXAMPLE
Get-EntraIDAccessToken

#>
function Get-EntraIDAccessToken {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $false)]
        [String] $Profile = "Default",

        [Parameter(Mandatory = $false)]
        [switch] $ForceRefresh
    )

    Process {
        if (!$Script:Profiles.ContainsKey($Profile)) {
            Write-Error "Profile $Profile does not exist"
            return
        }

        $P = $Script:Profiles[$Profile]

        # Do not try to get access token if we have an active access token
        if ($P.TokenCache -and !$ForceRefresh.IsPresent -and $P.TokenCache.ExpiresOn -gt (Get-Date).AddMinutes(5)) {
            Write-Debug "Using cached access token for profile $Profile"
            return $P.TokenCache.AccessToken
        }
        # Print verbose message differently depending on if we have an access token or not
        elseif (!$P.TokenCache) {
            Write-Verbose "Getting access token for profile $Profile"
        }
        else {
            Write-Verbose "Access token expired for profile $Profile, getting new access token"
        }

        if ($P.AuthenticationMethod -eq "clientsecret") {
            if (!$P.ClientSecret) {
                Write-Error "ClientSecretCredential must be specified when using clientsecret as authentication method"
                return
            }

            if (!$P.TenantId) {
                Write-Error "TenantId is not set"
                return
            }
        }
        elseif ($P.AuthenticationMethod -eq "azuredevopsfederatedcredential") {
            if (!$ENV:idToken) {
                Write-Error "Missing idToken environment variable (forgot addSpnToEnvironment?) when using Azure DevOps Federated Workload Identity as authentication method"
                return
            }

            if (!$P.TenantId) {
                Write-Error "TenantId is not set"
                return
            }
        }
        elseif ($P.AuthenticationMethod -eq "automationaccountmsi") {
            if (!$ENV:IDENTITY_HEADER) {
                Write-Error "Missing IDENTITY_HEADER environment variable when using Automation Acocunt Managed Service Identity as authentication method"
                return
            }

            if (!$ENV:IDENTITY_ENDPOINT) {
                Write-Error "Missing IDENTITY_ENDPOINT environment variable when using Automation Acocunt Managed Service Identity as authentication method"
                return
            }
        }
        else {
            Write-Error "Unknown authentication method: $($P.AuthenticationMethod)"
            return
        }
        
        try {
            if ($P.AuthenticationMethod -eq "clientsecret") {
                Write-Verbose "Getting access token using clientsecret with client_id $($P.ClientId)"
                # Build body for request and send it in order to get an access token
                $body = @{
                    client_id     = $P.ClientId
                    client_secret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($P.ClientSecret))
                    resource      = $P.Resource
                    grant_type    = "client_credentials"
                }
            
                # Get token
                $result = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($P.TenantId)/oauth2/token" -Body $body -ErrorAction Stop
            }
            elseif ($P.AuthenticationMethod -eq "azuredevopsfederatedcredential") {
                Write-Verbose "Getting access token using Azure DevOps Federated Workload Identity for client_id $($P.ClientId)"

                # Build body for request and send it in order to get an access token
                $body = @{
                    client_id             = $clientid
                    resource              = $P.Resource
                    grant_type            = "client_credentials"
                    client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                    client_assertion      = $ENV:idToken
                }
            
                # Get token
                $result = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($P.TenantId)/oauth2/token" -Body $body -ErrorAction Stop
            }
            elseif ($P.AuthenticationMethod -eq "automationaccountmsi" -and !$P.TrustingApplicationClientId) {
                $body = @{
                    'resource' = $P.Resource
                }

                if ($P.ClientId) {
                    Write-Verbose "Getting access token using Automation Account User Assigned Identity with client_id $($P.ClientId)"
                    $body['client_id'] = $P.ClientId
                }
                else {
                    Write-Verbose "Getting access token using Automation Account System Assigned Identity"
                }
                
                $result = Invoke-RestMethod $env:IDENTITY_ENDPOINT -Method 'POST' -Headers @{
                    'Metadata'          = 'true'
                    'X-IDENTITY-HEADER' = $env:IDENTITY_HEADER
                } -ContentType 'application/x-www-form-urlencoded' -Body $body
            }
        }
        catch {
            Write-Error "Caught error when getting access token: $($_)"
            return
        }

        if ($P.TrustingApplicationClientId) {
            try {
                Write-Verbose "Getting access token for trusting application with client_id $($P.TrustingApplicationClientId) using MSI with client_id $($P.ClientId)"
                $result = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($P.TenantId)/oauth2/token" -Body @{
                    client_id             = $P.TrustingApplicationClientId
                    client_assertion      = $result.access_token
                    resource              = $P.Resource
                    grant_type            = "client_credentials"
                    client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                } -ErrorAction Stop
            }
            catch {
                Write-Error "Caught error when getting access token: $($_)"
                return
            }
        }
    

        if (!$result.access_token) {
            Write-Error "Unable to retrieve access token from Entra ID"
            return
        }
        else {
            $decoded = $result.access_token | Get-EntraIDAccessTokenPayload
            Write-Verbose "Access token payload: $($decoded | ConvertTo-Json -Depth 10)"
        }
        
        # Save access token and when it expires
        $P.TokenCache = @{
            AccessToken = $result.access_token
            ExpiresOn   = (Get-Date).AddSeconds($result.expires_in - 360)
        }

        return $result.access_token
    }
}