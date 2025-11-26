<#
.SYNOPSIS
Gets an Entra ID Access Token in a header useable by Invoke-RestMethod or Invoke-WebRequest.

.DESCRIPTION
Gets an Entra ID Access Token in a header useable by Invoke-RestMethod or Invoke-WebRequest. Additional headers can be added using the AdditionalHeaders parameter.

.EXAMPLE
    Invoke-RestMethod "https://graph.microsoft.com/v1.0/users" -Headers (Get-EntraIDAccessTokenHeader)

.EXAMPLE
    Get-EntraIDAccessTokenHeader -Profile "API" -ConsistencyLevelEventual

.EXAMPLE
    Get-EntraIDAccessTokenHeader -Profile "API" -AdditionalHeaders @{"X-Custom-Header"="Value"}

.EXAMPLE
    $PSDefaultParameterValues["Invoke-RestMethod:Headers"] = {if($Uri -like "https://graph.microsoft.com/*") {Get-EntraIDAccessTokenHeader}}
    Invoke-RestMethod "https://graph.microsoft.com/v1.0/users"

.EXAMPLE
    $PSDefaultParameterValues["Invoke-WebRequest:Headers"] = {
        if($Uri -like "https://graph.microsoft.com/*") {Get-EntraIDAccessTokenHeader}
        if($Uri -like "https://api.fortytwo.io/*") {Get-EntraIDAccessTokenHeader -Profile "fortytwo"}
    }

    # Authenticated using the "default" profile
    Invoke-WebRequest "https://graph.microsoft.com/v1.0/users"

    # Authenticated using the "fortytwo" profile
    Invoke-WebRequest "https://api.fortytwo.io/something"
#>
function Get-EntraIDAccessTokenHeader {
    [CmdletBinding()]
    [Alias("GH")]
    [OutputType([System.Collections.Hashtable])]

    Param(
        [Parameter(Mandatory = $false)]
        [String] $Profile = "Default",

        [Parameter(Mandatory = $false)]
        [Switch] $ConsistencyLevelEventual,

        [Parameter(Mandatory = $false)]
        [System.Collections.Hashtable] $AdditionalHeaders = $null,

        [Parameter(Mandatory = $false)]
        [switch] $ForceRefresh
    )

    Process {
        $headers = @{
            Authorization = "Bearer $(Get-EntraIDAccessToken -Profile $Profile -ForceRefresh:$ForceRefresh)"
        }

        if($AdditionalHeaders) {
            $AdditionalHeaders.GetEnumerator() | ForEach-Object {
                $headers[$_.Key] = $_.Value
            }
        }

        if ($ConsistencyLevelEventual.IsPresent) {
            $headers["ConsistencyLevel"] = "eventual"
        }

        $headers
    }
}