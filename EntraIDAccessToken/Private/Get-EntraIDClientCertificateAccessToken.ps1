function Get-EntraIDClientCertificateAccessToken {
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
        $AssertionJWT = Get-SignedJWT -Payload @{
            "aud" = "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/token"
            "iss" = $AccessTokenProfile.ClientId
            "sub" = $AccessTokenProfile.ClientId
        } -Certificate $Certificate

        if ($AccessTokenProfile.V2Token) {
            $body = @{
                client_id             = $AccessTokenProfile.ClientId
                client_assertion      = $AssertionJWT
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                scope                 = [String]::IsNullOrEmpty($Scope) ? $AccessTokenProfile.Scope : $Scope
                grant_type            = "client_credentials"
            }

            Write-Verbose "Getting access token (v2) for '$($body.scope)' using Client Certificate for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token" -Body $body
        }
        else {
            $body = @{
                client_id             = $AccessTokenProfile.ClientId
                client_assertion      = $AssertionJWT
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                resource              = [String]::IsNullOrEmpty($Resource) ? $AccessTokenProfile.Resource : $Resource
                grant_type            = "client_credentials"
            }

            Write-Verbose "Getting access token (v1) for '$($body.resource)' using Client Certificate for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/token" -Body $body
        }        
    }
}