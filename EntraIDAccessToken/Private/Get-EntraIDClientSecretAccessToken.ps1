function Get-EntraIDClientSecretAccessToken {
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
                client_id     = $AccessTokenProfile.ClientId
                client_secret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($AccessTokenProfile.ClientSecret))
                scope         = $Scope ?? $AccessTokenProfile.Scope
                grant_type    = "client_credentials"
            }

            Write-Verbose "Getting access token (v2) for '$($body.scope)' using Client Secret for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token" -Body $body
        }
        else {
            $body = @{
                client_id     = $AccessTokenProfile.ClientId
                client_secret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($AccessTokenProfile.ClientSecret))
                resource      = $Resource ?? $AccessTokenProfile.Resource
                grant_type    = "client_credentials"
            }

            Write-Verbose "Getting access token (v1) for '$($body.resource)' using Client Secret for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/token" -Body $body
        }        
    }
}