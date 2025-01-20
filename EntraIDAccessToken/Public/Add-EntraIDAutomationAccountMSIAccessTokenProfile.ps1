<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDAccessTokenProfile

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
