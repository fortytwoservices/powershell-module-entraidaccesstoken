<#
.SYNOPSIS
Returns whether the access token is for a user or an app

.DESCRIPTION
Returns whether the access token is for a user or an app

.EXAMPLE
    PS> Get-EntraIDAccessToken |Get-EntraIDAccessTokenType
#>
function Get-EntraIDAccessTokenType {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String] $AccessToken
    )

    Process {
        $Payload = $AccessToken | Get-EntraIDAccessTokenPayload
        $Payload.idtyp -eq "user" ? "user" : "app"
    }
}