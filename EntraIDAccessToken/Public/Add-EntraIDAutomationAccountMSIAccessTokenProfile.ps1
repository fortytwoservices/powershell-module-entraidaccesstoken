<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens using automation account managed identity.

.EXAMPLE
# Use the system assigned managed identity of the automation account
Add-EntraIDAutomationAccountMSIAccessTokenProfile

.EXAMPLE
# Use a user assigned managed identity of the automation account
Add-EntraIDAutomationAccountMSIAccessTokenProfile -ClientId "12345678-1234-1234-1234-123456789012"

.EXAMPLE
# Use a system assigned managed identity with a federated credential to an app registration
Add-EntraIDAutomationAccountMSIAccessTokenProfile -TenantId "12345678-1234-1234-1234-123456789012" -TrustingApplicationClientId "87654321-4321-4321-4321-210987654321"

.EXAMPLE
# Use a user assigned managed identity with a federated credential to an app registration
Add-EntraIDAutomationAccountMSIAccessTokenProfile -ClientId "12345678-1234-1234-1234-123456789012" -TenantId "12345678-1234-1234-1234-123456789012" -TrustingApplicationClientId "87654321-4321-4321-4321-210987654321"
#>
function Add-EntraIDAutomationAccountMSIAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $false)]
        [String] $Resource = "https://graph.microsoft.com",

        [Parameter(Mandatory = $true, ParameterSetName = "trustingapplication")]
        [String] $TenantId,

        [Parameter(Mandatory = $true, ParameterSetName = "trustingapplication")]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $TrustingApplicationClientId,

        [Parameter(Mandatory = $false)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        $Script:Profiles[$Name] = @{
            AuthenticationMethod        = "automationaccountmsi"
            ClientId                    = $ClientId
            Resource                    = $Resource
            TenantId                    = $TenantId
            TrustingApplicationClientId = $TrustingApplicationClientId
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
