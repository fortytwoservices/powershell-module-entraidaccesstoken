function Get-EntraIDGitHubFederatedCredentialAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile,

        [Parameter(Mandatory = $false, ParameterSetName = "v1")]
        [String] $Resource = $null,

        [Parameter(Mandatory = $false, ParameterSetName = "v2")]
        [String] $Scope = $null
    )

    Process {
        $Url = "{0}&audience={1}" -f $ENV:ACTIONS_ID_TOKEN_REQUEST_URL, "api://AzureADTokenExchange"
        Write-Verbose "Getting token exchange access token from $Url"
        $GitHubJWT = Invoke-RestMethod $Url -Headers @{Authorization = ("bearer {0}" -f $ENV:ACTIONS_ID_TOKEN_REQUEST_TOKEN) }

        if (!$GitHubJWT.Value) {
            Write-Error "Failed to get GitHub JWT"
            return
        }

        if ($AccessTokenProfile.V2Token) {
            $body = @{
                client_id             = $AccessTokenProfile.ClientId
                scope                 = [String]::IsNullOrEmpty($Scope) ? $AccessTokenProfile.Scope: $Scope
                grant_type            = "client_credentials"
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                client_assertion      = $GitHubJWT.Value # [System.Net.WebUtility]::UrlEncode($GitHubJWT.Value)
            }

            Write-Verbose "Getting access token (v2) for '$($body.scope)' using GitHub Federated Credential for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token" -Body $body
        }
        else {
            $body = @{
                client_id             = $AccessTokenProfile.ClientId
                resource              = [String]::IsNullOrEmpty($Resource) ? $AccessTokenProfile.Scope: $Resource
                grant_type            = "client_credentials"
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                client_assertion      = $GitHubJWT.Value # [System.Net.WebUtility]::UrlEncode($GitHubJWT.Value)
            }

            Write-Verbose "Getting access token (v1) for '$($body.scope)' using GitHub Federated Credential for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token" -Body $body
        }        
    }
}