<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens using the system assigned or user assigned identity on an Azure VM.

.DESCRIPTION
Adds a new profile for getting Entra ID access tokens using the system assigned or user assigned identity on an Azure VM.

.EXAMPLE
# Get a token for Microsoft Graph using the system assigned identity
Add-EntraIDAzureVMMSIAccessTokenProfile

.EXAMPLE
# Get a token for Microsoft Graph using a user assigned assigned identity
Add-EntraIDAzureVMMSIAccessTokenProfile -UserAssignedIdentityClientId "87654321-4321-4321-4321-210987654321"

.EXAMPLE
# Get a token for Microsoft Graph using an app registration with federated credentials from the system assigned identity
Add-EntraIDAzureVMAccessTokenProfile -TenantId "12345678-1234-1234-1234-123456789012" -TrustingApplicationClientId "87654321-4321-4321-4321-210987654321"

.EXAMPLE
# Get a token for Microsoft Graph using an app registration with federated credentials from a user assigned identity
Add-EntraIDAzureVMAccessTokenProfile -TenantId "12345678-1234-1234-1234-123456789012" -TrustingApplicationClientId "87654321-4321-4321-4321-210987654321" -UserAssignedIdentityClientId "87654321-4321-4321-4321-210987654321"

.EXAMPLE
# Get a token for Fortytwo Universe using an app registration with federated credentials from the system assigned identity
Add-EntraIDAzureVMAccessTokenProfile -TenantId "12345678-1234-1234-1234-123456789012" -TrustingApplicationClientId "87654321-4321-4321-4321-210987654321" -Scope "https://api.fortytwo.io/.default"
#>
function Add-EntraIDAzureVMMSIAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName = "resource")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $false, ParameterSetName = "resource")]
        [Parameter(Mandatory = $false, ParameterSetName = "resource+trustingapplication")]
        [String] $Resource = "https://graph.microsoft.com",

        [Parameter(Mandatory = $true, ParameterSetName = "scope+trustingapplication")]
        [String] $Scope,

        [Parameter(Mandatory = $true, ParameterSetName = "resource+trustingapplication")]
        [Parameter(Mandatory = $true, ParameterSetName = "scope+trustingapplication")]
        [String] $TenantId,

        [Parameter(Mandatory = $true, ParameterSetName = "resource+trustingapplication")]
        [Parameter(Mandatory = $true, ParameterSetName = "scope+trustingapplication")]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $TrustingApplicationClientId,

        [Parameter(Mandatory = $false)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $UserAssignedIdentityClientId
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        $Script:Profiles[$Name] = @{
            AuthenticationMethod         = "azurevmmsi"
            UserAssignedIdentityClientId = $UserAssignedIdentityClientId
            Resource                     = $PSCmdlet.ParameterSetName -like "resource*" ? $Resource : $null
            Scope                        = $PSCmdlet.ParameterSetName -like "scope*" ? $Scope : $null
            TenantId                     = $TenantId
            TrustingApplicationClientId  = $TrustingApplicationClientId
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
