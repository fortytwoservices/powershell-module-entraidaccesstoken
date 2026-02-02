function Get-EntraIDClientCertificateAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile,

        [Parameter(Mandatory = $false)]
        [String] $FMIPath = $null,

        [Parameter(Mandatory = $false, ParameterSetName = "resource")]
        [String] $Resource = $null,

        [Parameter(Mandatory = $false, ParameterSetName = "scope")]
        [String] $Scope = $null
    )

    Process {
        $AssertionJWT = Get-SignedJWT -Payload @{
            "aud" = "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/token"
            "iss" = $AccessTokenProfile.ClientId
            "sub" = $AccessTokenProfile.ClientId
        } -Certificate $AccessTokenProfile.Certificate

        if ($Scope -or $AccessTokenProfile.scope) {
            $body = @{
                client_id             = $AccessTokenProfile.ClientId
                client_assertion      = $AssertionJWT
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                scope                 = [String]::IsNullOrEmpty($Scope) ? $AccessTokenProfile.Scope: $Scope
                grant_type            = "client_credentials"
            }

            if(![String]::IsNullOrEmpty($FMIPath)) {
                $body["fmi_path"] = $FMIPath
            }

            Write-Verbose "Getting access token (v2/scope) for '$($body.scope)' using Client Certificate for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            $uri = "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token"
            Write-Debug "POST $uri`n`n$(($body.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "`n&")"
            Invoke-RestMethod -Method Post -Uri $uri -Body $body
        }
        else {
            $body = @{
                client_id             = $AccessTokenProfile.ClientId
                client_assertion      = $AssertionJWT
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                resource              = [String]::IsNullOrEmpty($Resource) ? $AccessTokenProfile.Resource : $Resource
                grant_type            = "client_credentials"
            }

            Write-Verbose "Getting access token (v1/resource) for '$($body.resource)' using Client Certificate for client_id $($AccessTokenProfile.ClientId)"

            if(![String]::IsNullOrEmpty($FMIPath)) {
                Write-Warning "FMIPath parameter is not applicable for v1/resource authentication."
            }
        
            # Get token
            $uri = "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/token"
            Write-Debug "POST $uri`n`n$(($body.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "`n&")"
            Invoke-RestMethod -Method Post -Uri $uri -Body $body
        }        
    }
}