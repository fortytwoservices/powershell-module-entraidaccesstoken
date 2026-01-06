function Get-EntraIDUserFederatedIdentityCredentialAccessToken {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile
    )

    process {
        # Get the assertion profile
        if (-not $Script:Profiles.ContainsKey($AccessTokenProfile.ClientAssertionProfile)) {
            throw "Assertion profile $($AccessTokenProfile.ClientAssertionProfile) does not exist"
        }
        
        # Get the user fic
        if (-not $Script:Profiles.ContainsKey($AccessTokenProfile.UserFederatedIdentityCredentialProfile)) {
            throw "Assertion profile $($AccessTokenProfile.UserFederatedIdentityCredentialProfile) does not exist"
        }

        $user_federated_identity_credential_profile = Get-EntraIDAccessTokenProfile -Profile $AccessTokenProfile.UserFederatedIdentityCredentialProfile
        $client_assertion = Get-EntraIDAccessToken -Profile $AccessTokenProfile.ClientAssertionProfile
        $user_federated_identity_credential = Get-EntraIDAccessToken -Profile $AccessTokenProfile.UserFederatedIdentityCredentialProfile

        $body = @{
            client_id             = $user_federated_identity_credential_profile.ClientId
            client_assertion      = $client_assertion
            client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
            scope                 = $Scope
            grant_type            = "user_fic"
            user_federated_identity_credential = $user_federated_identity_credential
        }

        if($AccessTokenProfile.UserId) {
            $body["user_id"] = $AccessTokenProfile.UserId
        } elseif($AccessTokenProfile.Username) {
            $body["username"] = $AccessTokenProfile.Username
        } else {
            throw "Either UserId or Username must be provided in the profile"
        }

        Write-Verbose "Getting access token (v2/scope) for '$($body.scope)' using federated credential for user $($body.user_id ?? $body.username) with client assertion for client_id $($body.client_id)"
        
        # Get token
        Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($user_federated_identity_credential_profile.TenantId)/oauth2/v2.0/token" -Body $body
    }
}