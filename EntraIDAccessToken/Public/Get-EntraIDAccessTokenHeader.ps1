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
        [String] $Profile = "Default",

        [Parameter(Mandatory = $false)]
        [Switch] $ConsistencyLevelEventual
    )

    Process {
        $headers = @{
            Authorization = "Bearer $(Get-EntraIDAccessToken -Profile $Profile)"
        }

        if ($ConsistencyLevelEventual.IsPresent) {
            $headers["ConsistencyLevel"] = "eventual"
        }

        $headers
    }
}