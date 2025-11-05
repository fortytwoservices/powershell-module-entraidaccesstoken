<#
.SYNOPSIS
Gets an Entra ID Access Token in a header useable by Invoke-RestMethod or Invoke-WebRequest.

.DESCRIPTION
Gets an Entra ID Access Token in a header useable by Invoke-RestMethod or Invoke-WebRequest. Additional headers can be added using the AdditionalHeaders parameter.

.EXAMPLE
    PS> Invoke-RestMethod "https://graph.microsoft.com/v1.0/users" -Headers (Get-EntraIDAccessTokenHeader)

.EXAMPLE
    PS> Get-EntraIDAccessTokenHeader -Profile "API" -ConsistencyLevelEventual

.EXAMPLE
    PS> Get-EntraIDAccessTokenHeader -Profile "API" -AdditionalHeaders @{"X-Custom-Header"="Value"}
#>
function Get-EntraIDAccessTokenHeader {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]

    Param(
        [Parameter(Mandatory = $false)]
        [String] $Profile = "Default",

        [Parameter(Mandatory = $false)]
        [Switch] $ConsistencyLevelEventual,

        [Parameter(Mandatory = $false)]
        [System.Collections.Hashtable] $AdditionalHeaders = $null
    )

    Process {
        $headers = @{
            Authorization = "Bearer $(Get-EntraIDAccessToken -Profile $Profile)"
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