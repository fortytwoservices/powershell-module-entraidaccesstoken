<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDAccessTokenProfile

#>
function Add-EntraIDAutomationAccountMSIAccessTokenProfile {
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Profile = "Default",

        [Parameter(Mandatory = $false)]
        [String] $Resource = "https://graph.microsoft.com",

        [Parameter(Mandatory = $true)]
        [String] $TenantId,

        [Parameter(Mandatory = $false)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $TrustingApplicationClientId,

        [Parameter(Mandatory = $false)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Profile)) {
            Write-Warning "Profile $Profile already exists, overwriting"
        }

        $Script:Profiles[$Profile] = @{
            AuthenticationMethod        = "automationaccountmsi"
            ClientId                    = $ClientId
            Resource                    = $Resource
            TenantId                    = $TenantId
            TrustingApplicationClientId = $TrustingApplicationClientId
        }

        Get-EntraIDAccessToken -Profile $Profile | Out-Null
    }
}
