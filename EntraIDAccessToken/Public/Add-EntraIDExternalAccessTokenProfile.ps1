<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDExternalAccessTokenProfile

#>
function Add-EntraIDExternalAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName = "v1")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Profile = "Default",

        [Parameter(Mandatory = $false)]
        [String] $AccessToken
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Profile)) {
            Write-Warning "Profile $Profile already exists, overwriting"
        }

        $Script:Profiles[$Profile] = @{
            AuthenticationMethod = "externalaccesstoken"
            AccessToken          = $AccessToken
        }

        Get-EntraIDAccessToken -Profile $Profile | Out-Null
    }
}
