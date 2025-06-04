function ConvertFrom-EntraIDAccessToken {
    [CmdletBinding()]
    
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String] $AccessToken,

        [Parameter(Mandatory = $false)]
        [Switch] $AsHashTable
    )

    Process {
        if ($AccessToken -notlike "*.*.*") {
            Write-Error "AccessToken is not a valid JWT token. Expected format: header.payload.signature"
            return
        }

        $headerjson = $AccessToken.Split(".")[0]
        $headerjson = $headerjson.PadRight($headerjson.Length + (4 - ($headerjson.Length % 4)), "=").Replace("====", "")
        try {
            $header = ConvertFrom-Json -InputObject ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($headerjson))) -AsHashtable:$AsHashTable
        }
        catch {
            Write-Error "Failed to decode the JWT header: $_"
            return
        }

        $payload = Get-EntraIDAccessTokenPayload -InputObject $AccessToken -AsHashtable:$AsHashTable
        
        @{
            Header    = $header
            Payload   = $payload
            Signature = $AccessToken.Split(".")[2]
        }
    }
}