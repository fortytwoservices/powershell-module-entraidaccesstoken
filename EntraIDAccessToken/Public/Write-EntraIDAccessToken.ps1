<#
.SYNOPSIS
    Write an Entra ID Access Token to the console with color coding.

.DESCRIPTION
    Write an Entra ID Access Token to the console with color coding.

.EXAMPLE
    PS> Get-EntraIDAccessToken | Write-EntraIDAccessToken
#>

function Write-EntraIDAccessToken {
    [CmdletBinding()]
    [Alias("WAT")]
    [OutputType([System.String])]
    
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $AccessToken
    )

    Process {
        if ($AccessToken.Authorization -like "bearer *") {
            $AccessToken = $AccessToken.Authorization
        }
        $AccessToken = $AccessToken -ireplace "^bearer "

        if ($AccessToken -notlike "*.*.*") {
            throw "Unable to parse AccessToken"
        }        
        
        $Decoded = $AccessToken | ConvertFrom-EntraIDAccessToken -AsHashTable

        "$($PSStyle.Foreground.BrightYellow)$($Decoded.Header | ConvertTo-Json)$($PSStyle.Reset).$($PSStyle.Foreground.BrightGreen)$($Decoded.Payload | ConvertTo-Json)$($PSStyle.Reset)"
    }
}