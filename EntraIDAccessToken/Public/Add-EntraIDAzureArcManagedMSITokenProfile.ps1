<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens using the system assigned identity on an Azure Arc enabled server.

.DESCRIPTION
Adds a new profile for getting Entra ID access tokens using the system assigned identity on an Azure Arc enabled server.

.EXAMPLE
# Get a token for Microsoft Graph
Add-EntraIDAzureArcManagedMSITokenProfile

.EXAMPLE
# Get a token for Microsoft Graph using an app registration with federated credentials from the system assigned identity
Add-EntraIDAzureArcManagedMSITokenProfile -TenantId "12345678-1234-1234-1234-123456789012" -TrustingApplicationClientId "87654321-4321-4321-4321-210987654321"

#>
function Add-EntraIDAzureArcManagedMSITokenProfile {
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
            AuthenticationMethod        = "azurearcmsi"
            ClientId                    = $ClientId
            Resource                    = $Resource
            TenantId                    = $TenantId
            TrustingApplicationClientId = $TrustingApplicationClientId
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
