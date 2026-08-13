function Get-EntraIDFederatedTokenFileAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile,

        [Parameter(Mandatory = $false, ParameterSetName = "scope")]
        [String] $Scope = $null
    )

    Process {
        $body = @{
            client_id     = $AccessTokenProfile.ClientId
            client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
            client_assertion = (Get-Content -Path $AccessTokenProfile.File -Raw).Trim()
            scope         = [String]::IsNullOrEmpty($Scope) ? $AccessTokenProfile.Scope: $Scope
            grant_type    = "client_credentials"
        }

        Write-Verbose "Getting access token (v2/scope) for '$($body.scope)' using federated token file for client_id $($AccessTokenProfile.ClientId)"
        
        # Get token
        $uri = "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token"
        Write-Debug "POST $uri`n`n$(($body.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "`n&")"
        Invoke-RestMethod -Method Post -Uri $uri -Body $body      
    }
}