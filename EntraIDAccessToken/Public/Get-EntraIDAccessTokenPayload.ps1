<#
.SYNOPSIS
Decodes an input access token and returns the payload as a PowerShell object

.EXAMPLE
Get-EntraIDAccessToken | Get-EntraIDAccessTokenPayload

#>
function Get-EntraIDAccessTokenPayload {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String] $InputObject
    )

    Process {
        if($InputObject -notlike "*.*.*") {
            Write-Error "InputObject is not a valid JWT token. Expected format: header.payload.signature"
            return
        }

        $payload = $InputObject.Split(".")[1]
        $payload = $payload.PadRight($payload.Length + (4 - ($payload.Length % 4)), "=").Replace("====", "")
        ConvertFrom-Json -InputObject ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($payload)))    
    }
}