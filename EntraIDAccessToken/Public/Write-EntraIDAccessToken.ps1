function Write-EntraIDAccessToken {
    [CmdletBinding()]
    
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String] $AccessToken
    )

    Process {
        if($AccessToken -notlike "*.*.*") {
            Write-Error "AccessToken is not a valid JWT token. Expected format: header.payload.signature"
            return
        }
        
        $Decoded = $AccessToken | ConvertFrom-EntraIDAccessToken -AsHashTable

        Write-Host "$($PSStyle.Foreground.BrightYellow)$($Decoded.Header | ConvertTo-Json)$($PSStyle.Reset).$($PSStyle.Foreground.BrightGreen)$($Decoded.Payload | ConvertTo-Json)$($PSStyle.Reset)"
        
    }
}