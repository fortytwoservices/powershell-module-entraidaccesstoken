function Get-EntraIDAzureDevOpsFederatedCredentialAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile,

        [Parameter(Mandatory = $false, ParameterSetName = "v1")]
        [NullString] $Resource = $null,

        [Parameter(Mandatory = $false, ParameterSetName = "v2")]
        [NullString] $Scope = $null
    )

    Process {
        if ($AccessTokenProfile.V2Token) {
            $body = @{
                client_id             = $AccessTokenProfile.ClientId
                scope                 = $Scope ?? $AccessTokenProfile.Scope
                grant_type            = "client_credentials"
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                client_assertion      = $ENV:idToken
            }

            Write-Verbose "Getting access token (v2) for '$($body.scope)' using Azure DevOps Federated Workload Identity for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token" -Body $body
        }
        else {
            $body = @{
                client_id             = $AccessTokenProfile.ClientId
                resource              = $Resource ?? $AccessTokenProfile.Resource
                grant_type            = "client_credentials"
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                client_assertion      = $ENV:idToken
            }
            
            Write-Verbose "Getting access token (v1) for '$($body.resource)' using Azure DevOps Federated Workload Identity for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/token" -Body $body -ErrorAction Stop
        }        
    }
}