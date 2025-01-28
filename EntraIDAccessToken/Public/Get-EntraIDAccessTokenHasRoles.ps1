<#
.SYNOPSIS
Decodes an input access token and returns the payload as a PowerShell object

.EXAMPLE
Get-EntraIDAccessToken | Compare-EntraIDAccessTokenRoles -Roles "Group.Create","AdministrativeUnit.Read.All"

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