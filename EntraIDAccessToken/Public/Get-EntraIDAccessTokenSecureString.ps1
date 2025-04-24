<#
.SYNOPSIS
Gets an access token from Entra ID for the configured profile

.EXAMPLE
Get-EntraIDAccessToken

#>
function Get-EntraIDAccessTokenSecureString {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $false)]
        [String] $Profile = "Default"
    )

    Process {
        ConvertTo-SecureString -String (Get-EntraIDAccessToken -Profile $Profile) -AsPlainText -Force
    }
}