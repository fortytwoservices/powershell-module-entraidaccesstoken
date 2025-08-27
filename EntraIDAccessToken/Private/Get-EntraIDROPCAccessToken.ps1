function Get-EntraIDROPCAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile
    )

    process {
        $cred = [pscredential]::new($AccessTokenProfile.ClientId, $AccessTokenProfile.ClientSecret)

        # If we already have a refresh token, use that to get a new access token
        if ($AccessTokenProfile["RefreshToken"]) {
            Write-Verbose "We have a refresh token, using it to get a new access token"
            $tokenUrl = "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token"
            $body = @{
                grant_type    = "refresh_token"
                client_id     = $AccessTokenProfile.ClientId
                refresh_token = $AccessTokenProfile["RefreshToken"]
                scope         = $AccessTokenProfile.Scope
                client_secret = $cred.GetNetworkCredential().Password
            }

            $response = Invoke-RestMethod -Method Post -Uri $tokenUrl -Body $body -ContentType "application/x-www-form-urlencoded"

            if ($response.refresh_token) {
                Write-Debug "Received new refresh token, storing it for later use"
                $AccessTokenProfile["RefreshToken"] = $response.refresh_token
            }
            
            if ($response.access_token) {
                $response
                return
            }
            else {
                Write-Error "Failed to obtain access token, going into interactive"
            }
        }

        $body = @{
            grant_type    = "password"
            client_id     = $AccessTokenProfile.ClientId
            response_type = "token"
            scope         = $AccessTokenProfile.Scope
            client_secret = $cred.GetNetworkCredential().Password
            username      = $AccessTokenProfile.UserCredential.UserName
            password      = $AccessTokenProfile.UserCredential.GetNetworkCredential().Password
        }
        Write-Verbose "Requesting token for $($body.scope) using the user $($AccessTokenProfile.UserCredential.UserName) and client $($body.client_id) for tenant $($AccessTokenProfile.TenantId)"
        $response = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token" -Method Post -Body $body -ContentType "application/x-www-form-urlencoded"

        if ($response.refresh_token) {
            Write-Debug "Received refresh token, storing it for later use"
            $AccessTokenProfile["RefreshToken"] = $response.refresh_token
        }

        if ($response.access_token) {
            Write-Verbose "Successfully retrieved access token"
            $response
        }
        else {
            Write-Error "Unable to retrieve access token"
        }
    }
}