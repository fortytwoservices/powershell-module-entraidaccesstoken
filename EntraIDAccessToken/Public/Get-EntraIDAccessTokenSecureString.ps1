<#
.SYNOPSIS
Gets an access token from Entra ID for the configured profile, as a secure string

.DESCRIPTION
Gets an access token from Entra ID for the configured profile, as a secure string

.EXAMPLE
    PS> Get-EntraIDAccessTokenSecureString

.EXAMPLE
    PS> Get-EntraIDAccessTokenSecureString -Profile "API"
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