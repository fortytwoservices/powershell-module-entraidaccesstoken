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
        [String] $Profile = "*"
    )

    Process {
        $Script:Profiles | 
        Where-Object Name -like $Profile | 
        Select-Object @{L="Profile";E={$Profile}}, TenantId, Resource,  AuthenticationMethod, ClientId
    }
}