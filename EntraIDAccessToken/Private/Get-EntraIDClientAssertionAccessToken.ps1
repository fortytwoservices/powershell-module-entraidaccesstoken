function Get-EntraIDClientAssertionAccessToken {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile
    )

    Process {
        # Get the assertion profile
        if (-not $Script:Profiles.ContainsKey($AccessTokenProfile.ClientAssertionProfile)) {
            throw "Assertion profile $($AccessTokenProfile.ClientAssertionProfile) does not exist"
        }

        $assertion = Get-EntraIDAccessToken -Profile $AccessTokenProfile.ClientAssertionProfile

        if ($Scope -or $AccessTokenProfile.scope) {
            $body = @{
                client_id             = $AccessTokenProfile.ClientId
                client_assertion      = $assertion
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                scope                 = [String]::IsNullOrEmpty($Scope) ? $AccessTokenProfile.Scope: $Scope
                grant_type            = "client_credentials"
            }

            Write-Verbose "Getting access token (v2/scope) for '$($body.scope)' using Client Certificate for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token" -Body $body
        }
        else {
            $body = @{
                client_id             = $AccessTokenProfile.ClientId
                client_assertion      = $assertion
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                resource              = [String]::IsNullOrEmpty($Resource) ? $AccessTokenProfile.Resource : $Resource
                grant_type            = "client_credentials"
            }

            Write-Verbose "Getting access token (v1/resource) for '$($body.resource)' using Client Certificate for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/token" -Body $body
        }
    }
}