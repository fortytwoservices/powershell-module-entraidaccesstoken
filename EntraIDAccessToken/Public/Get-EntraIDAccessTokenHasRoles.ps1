<#
.SYNOPSIS
Get a boolean indicating whether the input access token has all or any of the specified roles.

.DESCRIPTION
Get a boolean indicating whether the input access token has all or any of the specified roles.

.EXAMPLE
    PS> Get-EntraIDAccessToken |Get-EntraIDAccessTokenHasRoles -Roles "Group.Create"

.EXAMPLE
    PS> Get-EntraIDAccessToken |Get-EntraIDAccessTokenHasRoles -Roles "Group.Create", "Group.ReadWrite.All" -Any
#>
function Get-EntraIDAccessTokenHasRoles {
    [CmdletBinding(DefaultParameterSetName = "All")]

    Param(
        [Parameter(Mandatory = $true)]
        [String[]] $Roles,

        [Parameter(Mandatory = $true, ParameterSetName = "Any")]
        [Switch] $Any,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String] $AccessToken
    )

    Process {
        $Payload = $AccessToken | Get-EntraIDAccessTokenPayload

        if($Any.IsPresent) {
            return !!($Roles | Where-Object {$Payload.roles -contains $_})
        }

        return !($Roles | Where-Object {$Payload.roles -notcontains $_})
    }
}