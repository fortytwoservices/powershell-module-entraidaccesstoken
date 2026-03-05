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
    [Alias("GAT")]

    Param(
        [Parameter(Mandatory = $false)]
        [String] $Profile = "Default",
        
        [Parameter(Mandatory = $false)]
        [String] $FMIPath = $null,

        # If specified, a new access token will be requested even if the cached token is still valid
        [Parameter(Mandatory = $false)]
        [switch] $ForceRefresh
    )

    Process {
        if (!$Script:Profiles.ContainsKey($Profile)) {
            throw "Profile $Profile does not exist"
        }

        $P = $Script:Profiles[$Profile]
        $CacheKey = "{0}:::{1}" -f $Profile, $FMIPath

        Write-Debug "Cache key: $CacheKey"

        $TokenCacheEntry = $Script:TokenCache[$CacheKey]

        if ($TokenCacheEntry) {
            Write-Debug "Checking existing cached token"
        }

        if ($ForceRefresh.IsPresent) {
            Write-Debug "Force refresh is specified, ignoring cached token"
        }
        elseif (!$TokenCacheEntry) {
            Write-Debug "No cached token to use"
        }
        elseif ($TokenCacheEntry.ExpiresOn -le (Get-Date).AddMinutes(5)) {
            Write-Debug "Cached token is expired or about to expire, requesting new token"
        }
        else {
            Write-Debug "Using cached access token for profile $Profile"
            return $TokenCacheEntry.AccessToken
        }

        if ($P.AuthenticationMethod -eq "externalaccesstoken") {
            return $P.AccessToken
        }
        elseif ($P.AuthenticationMethod -eq 'agentuser') {
        
        }
        elseif ($P.AuthenticationMethod -eq "federatedcredential") {
            if (!$P.FederatedAccessTokenProfile) {
                throw "FederatedAccessTokenProfile must be specified when using federatedcredential as authentication method"
            }
        }
        elseif ($P.AuthenticationMethod -eq "clientsecret") {
            if (!$P.ClientSecret) {
                throw "ClientSecretCredential must be specified when using clientsecret as authentication method"
            }

            if (!$P.TenantId) {
                throw "TenantId is not set"
            }
        }
        elseif ($P.AuthenticationMethod -eq "clientcertificate") {
            if (!$P.Certificate) {
                throw "No certificate specificed for clientcertificate auth method"
            }

            if (!$P.TenantId) {
                throw "TenantId is not set"
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
                throw "TenantId is not set"
            }
        }
        elseif ($P.AuthenticationMethod -eq "githubfederatedcredential") {
            if (!$ENV:ACTIONS_ID_TOKEN_REQUEST_URL) {
                throw "Missing ACTIONS_ID_TOKEN_REQUEST_URL environment variable when using GitHub Federated Credential as authentication method"
            }

            if (!$ENV:ACTIONS_ID_TOKEN_REQUEST_TOKEN) {
                Write-Warning "In order to use federated credentials, please add the below to your action:`n`npermissions:`n    id-token: write"
                throw "Missing ACTIONS_ID_TOKEN_REQUEST_TOKEN environment variable when using GitHub Federated Credential as authentication method"
            }

            if (!$P.TenantId) {
                throw "TenantId is not set"
            }

            if (!$P.ClientId) {
                throw "ClientId is not set"
            }
        }
        elseif ($P.AuthenticationMethod -eq "automationaccountmsi") {
            if (!$ENV:IDENTITY_HEADER) {
                throw "Missing IDENTITY_HEADER environment variable when using Automation Account Managed Service Identity as authentication method"
            }

            if (!$ENV:IDENTITY_ENDPOINT) {
                throw "Missing IDENTITY_ENDPOINT environment variable when using Automation Account Managed Service Identity as authentication method"
            }
        }
        elseif ($P.AuthenticationMethod -eq "functionappmsi") {
            if (!$ENV:IDENTITY_HEADER) {
                throw "Missing IDENTITY_HEADER environment variable when using Function App Managed Service Identity as authentication method"
            }

            if (!$ENV:IDENTITY_ENDPOINT) {
                throw "Missing IDENTITY_ENDPOINT environment variable when using Function App Managed Service Identity as authentication method"
            }
        }
        elseif ($P.AuthenticationMethod -eq "azurearcmsi") {
            if (!$ENV:IDENTITY_ENDPOINT) {
                throw "Missing IDENTITY_ENDPOINT environment variable when using Azure Arc Managed Service Identity as authentication method"
            }
        }
        elseif ($P.AuthenticationMethod -eq "azurevmmsi") {
            if ($P.Scope -and !$P.TrustingApplicationClientId) {
                throw "Scope is only supported when using a trusting application with Azure VM Managed Service Identity"
            }
        }
        elseif ($P.AuthenticationMethod -eq "azurepowershellsession") {
            
        }
        elseif ($P.AuthenticationMethod -eq "interactiveuser") {
            if (!$P.ClientId) {
                throw "ClientId is not set"
            }
        }
        elseif ($P.AuthenticationMethod -eq "ropc") {
            if (!$P.ClientId) {
                throw "ClientId is not set"
            }

            if (!$P.ClientSecret) {
                throw "ClientSecret is not set"
            }

            if (!$P.UserCredential) {
                throw "UserCredential is not set"
            }
        }
        else {
            throw "Unknown authentication method: $($P.AuthenticationMethod)"
        }
        
        try {
            if ($P.AuthenticationMethod -eq "clientsecret") {
                $result = Get-EntraIDClientSecretAccessToken -AccessTokenProfile $P -FMIPath $FMIPath
            }
            elseif($P.AuthenticationMethod -eq 'agentuser') {
                $result = Get-EntraIDAgentUserAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "clientcertificate") {
                $result = Get-EntraIDClientCertificateAccessToken -AccessTokenProfile $P -FMIPath $FMIPath
            }
            elseif ($P.AuthenticationMethod -eq "federatedcredential") {
                $result = Get-EntraIDFederatedCredentialAccessToken -AccessTokenProfile $P -FMIPath $FMIPath
            }
            elseif ($P.AuthenticationMethod -eq "azuredevopsfederatedcredential") {
                $result = Get-EntraIDAzureDevOpsFederatedCredentialAccessToken -AccessTokenProfile $P -FMIPath $FMIPath
            }
            elseif ($P.AuthenticationMethod -eq "azurepowershellsession") {
                if (![string]::IsNullOrEmpty($FMIPath)) {
                    Write-Warning "FMIPath parameter is not applicable for Azure PowerShell Session authentication."
                }

                $result = Get-EntraIDAzurePowerShellSessionAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "interactiveuser") {
                if (![string]::IsNullOrEmpty($FMIPath)) {
                    Write-Warning "FMIPath parameter is not applicable for Interactive User authentication."
                }
                $result = Get-EntraIDInteractiveUserAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "ropc") {
                if (![string]::IsNullOrEmpty($FMIPath)) {
                    Write-Warning "FMIPath parameter is not applicable for Interactive User authentication."
                }

                $result = Get-EntraIDROPCAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "githubfederatedcredential") {
                if (![string]::IsNullOrEmpty($FMIPath)) {
                    Write-Warning "FMIPath parameter is not applicable for Interactive User authentication."
                }

                $result = Get-EntraIDGitHubFederatedCredentialAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "automationaccountmsi" -and !$P.TrustingApplicationClientId) {
                $result = Get-EntraIDAutomationAccountMSIAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "automationaccountmsi" -and $P.TrustingApplicationClientId) {
                $step1 = Get-EntraIDAutomationAccountMSIAccessToken -AccessTokenProfile $P -Resource "api://AzureADTokenExchange"
                $result = Get-EntraIDFederatedCredentialAccessTokenUsingJWT -AccessTokenProfile $P -JWT $step1.access_token -ClientId $P.TrustingApplicationClientId
            }
            elseif ($P.AuthenticationMethod -eq "functionappmsi" -and !$P.TrustingApplicationClientId) {
                $result = Get-EntraIDFunctionAppMSIAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "functionappmsi" -and $P.TrustingApplicationClientId) {
                $step1 = Get-EntraIDFunctionAppMSIAccessToken -AccessTokenProfile $P -Resource "api://AzureADTokenExchange"
                $result = Get-EntraIDFederatedCredentialAccessTokenUsingJWT -AccessTokenProfile $P -JWT $step1.access_token -ClientId $P.TrustingApplicationClientId
            }
            elseif ($P.AuthenticationMethod -eq "azurearcmsi" -and !$P.TrustingApplicationClientId) {
                $result = Get-EntraIDAzureArcManagedMSIAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "azurearcmsi" -and $P.TrustingApplicationClientId) {
                $step1 = Get-EntraIDAzureArcManagedMSIAccessToken -AccessTokenProfile $P -Resource "api://AzureADTokenExchange"
                $result = Get-EntraIDFederatedCredentialAccessTokenUsingJWT -AccessTokenProfile $P -JWT $step1.access_token -ClientId $P.TrustingApplicationClientId
            }
            elseif ($P.AuthenticationMethod -eq "azurevmmsi" -and !$P.TrustingApplicationClientId) {
                $result = Get-EntraIDAzureVMMSIAccessToken -AccessTokenProfile $P
            }
            elseif ($P.AuthenticationMethod -eq "azurevmmsi" -and $P.TrustingApplicationClientId) {
                $step1 = Get-EntraIDAzureVMMSIAccessToken -AccessTokenProfile $P -Resource "api://AzureADTokenExchange"
                $result = Get-EntraIDFederatedCredentialAccessTokenUsingJWT -AccessTokenProfile $P -JWT $step1.access_token -ClientId $P.TrustingApplicationClientId
            }
        }
        catch {
            if ("$_" -like "*AADSTS82008*") {
                if (!$ENV:NOWARNAADSTS82008) {
                    Write-Warning "Entra ID returned error AADSTS82008, which is expected for agentic applications. Remember to use -FMIPath to specify the target Agent Identity when using this access token profile. This warning can be muted using WarningPreference or by setting the NOWARNAADSTS82008 environment variable to any value."
                }
                
            }
            else {
                Write-Error "Caught error when getting access token: $($_)"
                return
            }
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
        $Script:TokenCache[$CacheKey] = @{
            AccessToken = $result.access_token
            ExpiresOn   = (Get-Date).AddSeconds($result.expires_in - 360)
        }

        return $result.access_token
    }
}