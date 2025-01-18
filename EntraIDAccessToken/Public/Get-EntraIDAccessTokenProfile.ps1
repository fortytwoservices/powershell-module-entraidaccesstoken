<#
.SYNOPSIS
Gets an access token from Entra ID for the configured profile

.EXAMPLE
Get-EntraIDAccessTokenProfile

#>
function Get-EntraIDAccessTokenProfile {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $false)]
        [String] $Profile = "Default"
    )

    Process {
        if($Profile) {
            if (!$Script:Profiles.ContainsKey($Profile)) {
                Write-Error "Profile $Profile does not exist"
                return
            }

            $Script:Profiles[$Profile] | Select-Object @{L="Profile";E={$Profile}}, TenantId, Resource,  AuthenticationMethod, ClientId
        } else {
            $Script:Profiles | Select-Object @{L="Profile";E={$Profile}}, TenantId, Resource,  AuthenticationMethod, ClientId
        }
    }
}