function Get-EntraIDFederatedCredentialAccessTokenUsingJWT {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile,
        
        [Parameter(Mandatory = $true)]
        [String] $JWT,
        
        [Parameter(Mandatory = $true)]
        [String] $ClientId,

        [Parameter(Mandatory = $false, ParameterSetName = "resource")]
        [String] $Resource = $null,

        [Parameter(Mandatory = $false, ParameterSetName = "scope")]
        [String] $Scope = $null
    )

    Process {
        if ($PSCmdlet.ParameterSetName -eq "scope" -or $AccessTokenProfile.Scope) {
            $body = @{
                client_id             = $ClientId
                client_assertion      = $JWT
                scope                 = [String]::IsNullOrEmpty($Scope) ? $AccessTokenProfile.Scope: $Scope
                grant_type            = "client_credentials"
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
            }

            Write-Verbose "Getting access token (v2/scope) for $($body.scope) with federated credentials for client_id $($ClientId)"

            $uri = "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token"
            Write-Debug "POST $uri`n`n$(($body.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "`n&")"
            Invoke-RestMethod -Method Post -Uri $uri -Body $body -ErrorAction Stop
        }
        else {
            $body = @{
                client_id             = $ClientId
                client_assertion      = $JWT
                resource              = [String]::IsNullOrEmpty($Resource) ? $AccessTokenProfile.Resource : $Resource
                grant_type            = "client_credentials"
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
            }

            Write-Verbose "Getting access token (v1/resource) for resource $($body.resource) with federated credentials for client_id $($ClientId)"

            $uri = "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/token"
            Write-Debug "POST $uri`n`n$(($body.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "`n&")"
            Invoke-RestMethod -Method Post -Uri $uri -Body $body -ErrorAction Stop
        }
    }
}