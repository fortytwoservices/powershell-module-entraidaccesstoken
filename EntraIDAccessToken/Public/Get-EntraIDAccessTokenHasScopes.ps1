<#
.SYNOPSIS
Get a boolean indicating whether the input access token has all or any of the specified roles.

.DESCRIPTION
Get a boolean indicating whether the input access token has all or any of the specified roles.

.EXAMPLE
    PS> Get-EntraIDAccessToken |Get-EntraIDAccessTokenHasScopes -Scopes "Group.Read.All"

.EXAMPLE
    PS> Get-EntraIDAccessToken |Get-EntraIDAccessTokenHasScopes -Scopes "Group.Read.All", "Group.ReadWrite.All" -Any
#>
function Get-EntraIDAccessTokenHasScopes {
    [CmdletBinding(DefaultParameterSetName = "All")]
    [OutputType([System.Boolean])]

    Param(
        [Parameter(Mandatory = $true)]
        [String[]] $Scopes,

        [Parameter(Mandatory = $true, ParameterSetName = "Any")]
        [Switch] $Any,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String] $AccessToken
    )

    Process {
        $Payload = $AccessToken | Get-EntraIDAccessTokenPayload

        $PayloadScopes = $Payload.scp -split " " | ForEach-Object { $_.Trim() }

        if($Any.IsPresent) {
            return !!($Scopes | Where-Object {$PayloadScopes -contains $_})
        }

        return !($Scopes | Where-Object {$PayloadScopes -notcontains $_})
    }
}