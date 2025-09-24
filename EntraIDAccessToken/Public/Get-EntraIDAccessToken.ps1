<#
.SYNOPSIS
Gets an access token from Entra ID for the configured profile

.DESCRIPTION
Gets an access token from Entra ID for the configured profile. The access token is cached until it is close to expiration, and a new token will be requested automatically when needed.

.EXAMPLE
Get-EntraIDAccessToken

.EXAMPLE
Get-EntraIDAccessToken -Profile "API" -ForceRefresh

#>
function Get-EntraIDAccessToken {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $false)]
        [String] $Profile = "Default",

        # If specified, a new access token will be requested even if the cached token is still valid
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

        if ($P.AuthenticationMethod -eq "externalaccesstoken") {
            return $P.AccessToken
        } 
        elseif ($P.AuthenticationMethod -eq "clientsecret") {
            if (!$P.ClientSecret) {
                Write-Error "ClientSecretCredential must be specified when using clientsecret as authentication method"
                return
            }

            if (!$P.TenantId) {
                Write-Error "TenantId is not set"
                return
            }
        }
        elseif ($P.AuthenticationMethod -eq "clientcertificate") {
            if (!$P.Certificate) {
                Write-Error "No certificate specificed for clientcertificate auth method"
                return
            }

            if (!$P.TenantId) {
                Write-Error "TenantId is not set"
                return
            }
        }
        elseif ($P.AuthenticationMethod -eq "azuredevopsfederatedcredential") {
            if (!$ENV:idToken) {
                $Example = '- task: AzureCLI@2
    displayName: Example task
    inputs:
        azureSubscription: example-service-connection
        scriptLocation: scriptPath
        scriptPath: "$(Build.SourcesDirectory)/Example.ps1"
        azurePowerShellVersion: "LatestVersion"
        scriptType: pscore
        addSpnToEnvironment: true
    env:
        SYSTEM_ACCESSTOKEN: $(System.AccessToken)'
                Write-Warning "Example task: `n$Example"
                throw "Missing idToken environment variable, did you forget addSpnToEnvironment?"
            }

            if (!$P.TenantId) {
                Write-Error "TenantId is not set"
                return
            }
        }
        elseif ($P.AuthenticationMethod -eq "githubfederatedcredential") {
            if (!$ENV:ACTIONS_ID_TOKEN_REQUEST_URL) {
                Write-Error "Missing ACTIONS_ID_TOKEN_REQUEST_URL environment variable when using GitHub Federated Credential as authentication method"
                return
            }

            if (!$ENV:ACTIONS_ID_TOKEN_REQUEST_TOKEN) {
                Write-Error "Missing ACTIONS_ID_TOKEN_REQUEST_TOKEN environment variable when using GitHub Federated Credential as authentication method"
                return
            }

            if (!$P.TenantId) {
                Write-Error "TenantId is not set"
                return
            }

            if (!$P.ClientId) {
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
        elseif ($P.AuthenticationMethod -eq "functionappmsi") {
            if (!$ENV:IDENTITY_HEADER) {
                Write-Error "Missing IDENTITY_HEADER environment variable when using Function App Managed Service Identity as authentication method"
                return
            }

            if (!$ENV:IDENTITY_ENDPOINT) {
                Write-Error "Missing IDENTITY_ENDPOINT environment variable when using Function App Managed Service Identity as authentication method"
                return
            }
        }
        elseif ($P.AuthenticationMethod -eq "azurearcmsi") {
            if (!$ENV:IDENTITY_ENDPOINT) {
                Write-Error "Missing IDENTITY_ENDPOINT environment variable when using Azure Arc Managed Service Identity as authentication method"
                return
            }
        }
        elseif ($P.AuthenticationMethod -eq "azurepowershellsession") {
            
        }
        elseif ($P.AuthenticationMethod -eq "interactiveuser") {
            if (!$P.ClientId) {
                Write-Error "ClientId is not set"
                return
            }
        }
        elseif ($P.AuthenticationMethod -eq "ropc") {
            if (!$P.ClientId) {
                Write-Error "ClientId is not set"
                return
            }

            if(!$P.ClientSecret) {
                Write-Error "ClientSecret is not set"
                return
            }

            if(!$P.UserCredential) {
                Write-Error "UserCredential is not set"
                return
            }
        }
        else {
            Write-Error "Unknown authentication method: $($P.AuthenticationMethod)"
            return
        }
        
        try {
            if ($P.AuthenticationMethod -eq "clientsecret") {
                $result = Get-EntraIDClientSecretAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "clientcertificate") {
                $result = Get-EntraIDClientCertificateAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "azuredevopsfederatedcredential") {
                $result = Get-EntraIDAzureDevOpsFederatedCredentialAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "azurepowershellsession") {
                $result = Get-EntraIDAzurePowerShellSessionAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "interactiveuser") {
                $result = Get-EntraIDInteractiveUserAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "ropc") {
                $result = Get-EntraIDROPCAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "githubfederatedcredential") {
                $result = Get-EntraIDGitHubFederatedCredentialAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "automationaccountmsi" -and !$P.TrustingApplicationClientId) {
                $result = Get-EntraIDAutomationAccountMSIAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "automationaccountmsi" -and $P.TrustingApplicationClientId) {
                $step1 = Get-EntraIDAutomationAccountMSIAccessToken -AccessTokenProfile $P -Resource "api://AzureADTokenExchange"
                $result = Get-EntraIDFederatedCredentialAccessToken -AccessTokenProfile $P -JWT $step1.access_token -ClientId $P.TrustingApplicationClientId
            }
            elseif ($P.AuthenticationMethod -eq "functionappmsi" -and !$P.TrustingApplicationClientId) {
                $result = Get-EntraIDFunctionAppMSIAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "functionappmsi" -and $P.TrustingApplicationClientId) {
                $step1 = Get-EntraIDFunctionAppMSIAccessToken -AccessTokenProfile $P -Resource "api://AzureADTokenExchange"
                $result = Get-EntraIDFederatedCredentialAccessToken -AccessTokenProfile $P -JWT $step1.access_token -ClientId $P.TrustingApplicationClientId
            }
            elseif ($P.AuthenticationMethod -eq "azurearcmsi" -and !$P.TrustingApplicationClientId) {
                $result = Get-EntraIDAzureArcManagedMSIAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "azurearcmsi" -and $P.TrustingApplicationClientId) {
                $step1 = Get-EntraIDAzureArcManagedMSIAccessToken -AccessTokenProfile $P -Resource "api://AzureADTokenExchange"
                $result = Get-EntraIDFederatedCredentialAccessToken -AccessTokenProfile $P -JWT $step1.access_token -ClientId $P.TrustingApplicationClientId
            }
        }
        catch {
            Write-Error "Caught error when getting access token: $($_)"
            return
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