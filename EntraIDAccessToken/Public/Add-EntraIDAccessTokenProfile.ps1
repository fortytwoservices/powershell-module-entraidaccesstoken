<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDAccessTokenProfile

#>
function Add-EntraIDAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName = "clientsecret")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Profile = "Default",

        [Parameter(Mandatory = $false)]
        [String] $Resource = "https://graph.microsoft.com",

        [Parameter(Mandatory = $true, ParameterSetName = "clientsecret")]
        [Parameter(Mandatory = $true, ParameterSetName = "azuredevopsfederatedcredential")]
        [Parameter(Mandatory = $false, ParameterSetName = "interactive")]
        [String] $TenantId,

        [Parameter(Mandatory = $true, ParameterSetName = "clientsecret")]
        [securestring] $ClientSecret,

        [Parameter(Mandatory = $false, ParameterSetName = "automationaccountmsi")]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $TrustingApplicationClientId,

        [Parameter(Mandatory = $false, ParameterSetName = "automationaccountmsi")]
        [Parameter(Mandatory = $true, ParameterSetName = "azuredevopsfederatedcredential")]
        [Parameter(Mandatory = $true, ParameterSetName = "clientsecret")]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId,

        # Switch parameter used for specifying the authentication method (used only to set the parameter set)
        [Parameter(Mandatory = $true, ParameterSetName = "automationaccountmsi")]
        [Switch] $AutomationAccountManagedServiceIdentity,

        # Switch parameter used for specifying the authentication method (used only to set the parameter set)
        [Parameter(Mandatory = $true, ParameterSetName = "azuredevopsfederatedcredential")]
        [Switch] $AzureDevOpsFederatedCredential
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Profile)) {
            Write-Warning "Profile $Profile already exists, overwriting"
        }

        $Script:Profiles[$Profile] = @{
            AuthenticationMethod                    = $PSCmdlet.ParameterSetName
            AutomationAccountManagedServiceIdentity = $AutomationAccountManagedServiceIdentity
            AzureDevOpsFederatedCredential          = $AzureDevOpsFederatedCredential
            ClientId                                = $ClientId
            ClientSecret                            = $ClientSecret
            Resource                                = $Resource
            TenantId                                = $TenantId
            TrustingApplicationClientId             = $TrustingApplicationClientId
        }

        Get-EntraIDAccessToken -Profile $Profile | Out-Null
    }
}
