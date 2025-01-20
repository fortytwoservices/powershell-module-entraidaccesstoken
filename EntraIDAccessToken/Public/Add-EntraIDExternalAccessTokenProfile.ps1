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
        [String] $Name = "Default",

        [Parameter(Mandatory = $true)]
        [String] $AccessToken
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        $Script:Profiles[$Name] = @{
            AuthenticationMethod = "externalaccesstoken"
            AccessToken          = $AccessToken
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
