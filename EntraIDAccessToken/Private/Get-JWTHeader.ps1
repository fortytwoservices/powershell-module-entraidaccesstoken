<#
.Synopsis
    Creates a base64 string of a default JWT header, with certificate information
.DESCRIPTION
    Creates a base64 string of a default JWT header, with certificate information
.EXAMPLE
    Get-JWTHeader -Certificate $cert
#>
function Get-JWTHeader {
    [CmdletBinding()]
 
    param (
        [Parameter(Mandatory = $true)] $Certificate
    ) 
 
    Process {
        [System.Convert]::ToBase64String(([System.Text.Encoding]::UTF8.GetBytes((
                        [ordered] @{
                            "alg" = "RS256"
                            "kid" = $Certificate.Thumbprint
                            "x5t" = [uri]::EscapeDataString([System.Convert]::ToBase64String($Certificate.GetCertHash()))
                            "typ" = "JWT"
                        } | ConvertTo-Json -Compress
                    )))) -replace "=+$" # Required to remove padding
    }
}