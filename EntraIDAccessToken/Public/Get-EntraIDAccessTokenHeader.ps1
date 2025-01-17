<#
.SYNOPSIS
Uses the configured credentials for getting an access token for the Inbound Provisioning API. Internal helper method.

.EXAMPLE
Get-EntraIDAccessTokenHeader

#>
function Get-EntraIDAccessTokenHeader {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $false)]
        [String] $Profile = "Default"
    )

    Process {
        @{
            Authorization = "Bearer $(Get-EntraIDAccessToken -Profile $Profile)"
        }
    }
}