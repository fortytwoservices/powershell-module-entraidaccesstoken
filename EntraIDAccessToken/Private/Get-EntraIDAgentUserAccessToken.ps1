<#
.SYNOPSIS
Gets an Entra ID access token.

.EXAMPLE
Get-EntraIDAgentUserToken

#>
function Get-EntraIDAgentUserAccessToken {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile
    )
    
    Process {
        $agentIdentityProfile = $Script:Profiles[$AccessTokenProfile.AgentIdentityAccessTokenProfile]
        if (!$agentIdentityProfile) {
            Write-Error "Agent identity access token profile $($AccessTokenProfile.AgentIdentityAccessTokenProfile) does not exist"
            return
        }

        $blueprintProfile = $Script:Profiles[$agentIdentityProfile.FederatedAccessTokenProfile]
        if (!$blueprintProfile) {
            Write-Error "Federated access token profile $($agentIdentityProfile.FederatedAccessTokenProfile) does not exist"
            return
        }

        $BlueprintToken = Get-EntraIDAccessToken -Profile $agentIdentityProfile.FederatedAccessTokenProfile -FMIPath $agentIdentityProfile.ClientId
        $AgentIdentityToken = Get-EntraIDAccessToken -Profile $AccessTokenProfile.AgentIdentityAccessTokenProfile
        
        # $body = @{
        #     client_id             = $agentIdentityProfile.ClientId
        #     scope                 = $AccessTokenProfile.Scope
        #     client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
        #     client_assertion      = $BlueprintToken
        #     assertion             = $AgentIdentityToken
        #     username              = $AccessTokenProfile.UserPrincipalName
        #     grant_type            = "urn:ietf:params:oauth:grant-type:jwt-bearer"
        #     requested_token_use   = "on_behalf_of"
        # }

        $body = @{
            client_id                          = $agentIdentityProfile.ClientId
            scope                              = $AccessTokenProfile.Scope

            grant_type                         = "user_fic"
            client_assertion_type              = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
            client_assertion                   = $BlueprintToken
            user_id                            = $AccessTokenProfile.UserPrincipalName
            user_federated_identity_credential = $AgentIdentityToken
        }

        Write-Verbose "Getting access token (v2/scope) for '$($body.scope)' using agent user $($body.username) for client_id $($agentIdentityProfile.ClientId)"

        # Get token
        $uri = "https://login.microsoftonline.com/$($agentIdentityProfile.TenantId)/oauth2/v2.0/token"
        Write-Debug "POST $uri`n`n$(($body.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "`n&")"
        Invoke-RestMethod -Method Post -Uri $uri -Body $body

    }
}
