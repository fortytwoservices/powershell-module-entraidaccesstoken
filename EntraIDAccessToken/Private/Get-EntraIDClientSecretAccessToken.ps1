function Get-EntraIDClientSecretAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile,

        [Parameter(Mandatory = $false, ParameterSetName = "resource")]
        [String] $Resource = $null,

        [Parameter(Mandatory = $false, ParameterSetName = "scope")]
        [String] $Scope = $null
    )

    Process {
        $credential = [pscredential]::new($AccessTokenProfile.ClientId, $AccessTokenProfile.ClientSecret)

        if (($PSCmdlet.ParameterSetName -eq "scope" -or $AccessTokenProfile.scope) -and $AccessTokenProfile.V2Token) {
            $body = @{
                client_id     = $AccessTokenProfile.ClientId
                client_secret = $credential.GetNetworkCredential().Password
                scope         = [String]::IsNullOrEmpty($Scope) ? $AccessTokenProfile.Scope: $Scope
                grant_type    = "client_credentials"
            }

            Write-Verbose "Getting access token (v2) for '$($body.scope)' using Client Secret for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token" -Body $body
        }
        elseif ($PSCmdlet.ParameterSetName -eq "scope" -or $AccessTokenProfile.scope) {
            $body = @{
                client_id     = $AccessTokenProfile.ClientId
                client_secret = $credential.GetNetworkCredential().Password
                scope         = [String]::IsNullOrEmpty($Scope) ? $AccessTokenProfile.Scope: $Scope
                grant_type    = "client_credentials"
            }

            Write-Verbose "Getting access token (v1) for '$($body.scope)' using Client Secret for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/token" -Body $body
        }
        else {
            $body = @{
                client_id     = $AccessTokenProfile.ClientId
                client_secret = $credential.GetNetworkCredential().Password
                resource      = [String]::IsNullOrEmpty($Resource) ? $AccessTokenProfile.Resource : $Resource
                grant_type    = "client_credentials"
            }

            Write-Verbose "Getting access token (v1) for '$($body.resource)' using Client Secret for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/token" -Body $body
        }        
    }
}