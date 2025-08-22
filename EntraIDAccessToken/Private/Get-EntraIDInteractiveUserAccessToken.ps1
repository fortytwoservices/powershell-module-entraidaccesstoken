function Get-EntraIDInteractiveUserAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile
    )

    process {
        # If we already have a refresh token, use that to get a new access token
        if ($AccessTokenProfile["RefreshToken"]) {
            Write-Verbose "We have a refresh token, using it to get a new access token"
            $tokenUrl = "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token"
            $body = @{
                grant_type    = "refresh_token"
                client_id     = $AccessTokenProfile.ClientId
                refresh_token = $AccessTokenProfile["RefreshToken"]
                scope         = $AccessTokenProfile.Scope
            }

            $response = Invoke-RestMethod -Method Post -Uri $tokenUrl -Body $body -ContentType "application/x-www-form-urlencoded" -Headers @{
                Origin = "{0}://localhost:{1}/" -f ($AccessTokenProfile.Https ? "https" : "http"), $AccessTokenProfile.LocalhostPort
            }

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

        # Create listener
        if ($AccessTokenProfile.Https) {
            Write-Verbose "Creating HTTPS listener on port $($AccessTokenProfile.LocalhostPort)"
            $listener = New-Object System.Net.HttpListener
            $listener.Prefixes.Add("https://localhost:$($AccessTokenProfile.LocalhostPort)/")
        }
        else {
            Write-Verbose "Creating HTTP listener on port $($AccessTokenProfile.LocalhostPort)"
            $listener = New-Object System.Net.HttpListener
            $listener.Prefixes.Add("http://localhost:$($AccessTokenProfile.LocalhostPort)/")
        }

        Write-Verbose "Starting listener"
        $listener.Start()

        # Calculate the url to send the user to - Thanks to https://github.com/darrenjrobinson/PKCE/blob/main/PKCE.psm1
        $codeVerifier = -join (((48..57) * 4) + ((65..90) * 4) + ((97..122) * 4) | Get-Random -Count 43 | ForEach-Object { [char]$_ })
        Write-Debug "Created code verifier: $($codeVerifier)"
        $hashAlgo = [System.Security.Cryptography.HashAlgorithm]::Create('sha256')
        $hash = $hashAlgo.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($codeVerifier))
        $b64Hash = [System.Convert]::ToBase64String($hash)
        $code_challenge = $b64Hash.Substring(0, 43)
        $code_challenge = $code_challenge.Replace("/", "_")
        $code_challenge = $code_challenge.Replace("+", "-")
        $code_challenge = $code_challenge.Replace("=", "")

        $authorizeUrl = "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/authorize?client_id=$($AccessTokenProfile.ClientId)&response_type=code&redirect_uri=http://localhost:$($AccessTokenProfile.LocalhostPort)/&scope=$($AccessTokenProfile.Scope)&code_challenge=$($code_challenge)&code_challenge_method=S256"

        # Display message or launch browser
        if ($AccessTokenProfile.LaunchBrowser) {
            Write-Verbose "Launching browser to url $($authorizeUrl)"
            Start-Process $authorizeUrl
        }
        else {
            Write-Host "Please navigate to the following URL in your browser: $($PSStyle.Foreground.BrightYellow)$($authorizeUrl)$($PSStyle.Reset)"
        }

        # Wait for incoming requests
        Write-Verbose "Wait for incoming request"
        $context = $listener.GetContext()
        $request = $context.Request

        $code = $request.QueryString["code"]
        $errorShort = $request.QueryString["error"]
        $errorDescription = $request.QueryString["error_description"]

        if ($code) {
            Write-Verbose "Writing success message back to http stream"
            $context.Response.OutputStream.Write([System.Text.Encoding]::UTF8.GetBytes("<html><body>Authorization code received. You can close this window now.</body></html>"))
        }
        else {
            $errorHtml = "<html><body>ERROR: Authorization code not received. Go back to powershell and retry.</body></html>"

            if ($errorShort -or $errorDescription) {
                $errorHtml = "<html><body><p><b>ERROR:</b> $($errorShort)</p><p>$($errorDescription)</p><p>Go back to powershell and retry.</p></body></html>"
            }
            Write-Verbose "Writing error message back to http stream"
            $context.Response.OutputStream.Write([System.Text.Encoding]::UTF8.GetBytes($errorHtml))
        }
        
        $context.Response.OutputStream.Close()
        $listener.Stop()

        if (!$code) {
            Write-Error "Unable to get authorization code"
            return
        }

        # Exchange the code for an access token
        Write-Verbose "Exchanging authorization code for access token"
        $tokenUrl = "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token"
        $body = @{
            client_id     = $AccessTokenProfile.ClientId
            scope         = $AccessTokenProfile.Scope
            code          = $code
            redirect_uri  = "{0}://localhost:{1}/" -f ($AccessTokenProfile.Https ? "https" : "http"), $AccessTokenProfile.LocalhostPort
            grant_type    = "authorization_code"
            code_verifier = $codeVerifier
        }

        $headers = @{
            Origin = "{0}://localhost:{1}/" -f ($AccessTokenProfile.Https ? "https" : "http"), $AccessTokenProfile.LocalhostPort
        }


        Write-Debug "Preparing body for token request:"
        $body.Keys | ForEach-Object {
            Write-Debug " - $($_) = $($body[$_])"
        }

        Write-Debug "Preparing headers for token request: $($headers | ConvertTo-Json)"

        $response = Invoke-RestMethod -Method Post -Uri $tokenUrl -Body $body -ContentType "application/x-www-form-urlencoded" -Headers $headers

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