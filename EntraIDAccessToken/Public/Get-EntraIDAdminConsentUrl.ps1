<#
.SYNOPSIS
Generates an admin consent URL for a given application

.DESCRIPTION
Generates an admin consent URL for a given application

.EXAMPLE
Get-EntraIDAccessTokenProfile | Get-EntraIDAdminConsentUrl

.EXAMPLE
Get-EntraIDAdminConsentUrl -ClientId "your-client-id"
#>
function Get-EntraIDAdminConsentUrl {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [String] $ClientId
    )

    Process {
        return "https://login.microsoftonline.com/common/adminconsent?client_id=$ClientId"
    }
}