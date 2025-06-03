function ConvertFrom-Base64UrlEncodedString {
    <#
    .SYNOPSIS
        Decodes a base 64 URL encoded string.
    .DESCRIPTION
        Decodes a base 64 URL encoded string such as a JWT header or payload.
    .PARAMETER InputString
        The string to be base64 URL decoded.
    .PARAMETER AsBytes
        Instructions this function to return the result as a byte array as opposed to a default string.
    .EXAMPLE
		"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9" | ConvertFrom-Base64UrlEncodedString

		Decodes a JWT header.
    .INPUTS
        System.String

            A string is received by the InputString parameter.
    .OUTPUTS
        System.String

            Returns a base 64 URL decoded string for the given input.
    .LINK
        https://tools.ietf.org/html/rfc4648#section-5
#>

    [CmdletBinding()]
    [OutputType([System.String], [System.Byte[]])]
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string] $InputString,

        [Parameter(Position = 1, Mandatory = $false)]
        [switch] $ByteArray
    )
    PROCESS {
        try {
            # Replace and pad
            $InputString = $InputString.Replace("-","+").Replace("_","/")
            $InputString = $InputString.PadRight($InputString.Length + (4 - ($InputString.Length % 4)), "=").Replace("====", "")

            if ($ByteArray.IsPresent) {
                [Convert]::FromBase64String($InputString)
            }
            else {
                [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($InputString))
            }
        }
        catch {
            Write-Error "Unable to decode base64"
        }
    }
}