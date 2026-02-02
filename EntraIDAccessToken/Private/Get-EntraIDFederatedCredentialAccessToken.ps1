function Get-EntraIDFederatedCredentialAccessToken {
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
        $Params = @{Profile  = $AccessTokenProfile.FederatedAccessTokenProfile}
        if ($AccessTokenProfile.AgentIdentity) {
            $Params["FMIPath"] = $AccessTokenProfile.ClientId
        }
        $JWT = Get-EntraIDAccessToken @params
        
        if ($PSCmdlet.ParameterSetName -eq "scope" -or $AccessTokenProfile.Scope) {
            $body = @{
                client_id             = $AccessTokenProfile.ClientId
                client_assertion      = $JWT
                scope                 = [String]::IsNullOrEmpty($Scope) ? $AccessTokenProfile.Scope: $Scope
                grant_type            = "client_credentials"
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
            }
            
            Write-Verbose "Getting access token (v2/scope) for $($body.scope) with federated credentials for client_id $($AccessTokenProfile.ClientId)"

            if (![string]::IsNullOrEmpty($FMIPath)) {
                Write-Verbose "Using FMIPath $FMIPath"
                $body["fmi_path"] = $FMIPath
            }

            $uri = "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token"
            Write-Debug "POST $uri`n`n$(($body.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "`n&")"
            Invoke-RestMethod -Method Post -Uri $uri -Body $body -ErrorAction Stop
        }
        else {
            $body = @{
                client_id             = $AccessTokenProfile.ClientId
                client_assertion      = $JWT
                resource              = [String]::IsNullOrEmpty($Resource) ? $AccessTokenProfile.Resource : $Resource
                grant_type            = "client_credentials"
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
            }

            Write-Verbose "Getting access token (v1/resource) for resource $($body.resource) with federated credentials for client_id $($AccessTokenProfile.ClientId)"

            if (![string]::IsNullOrEmpty($FMIPath)) {
                Write-Warning "FMIPath is not supported for v1/resource tokens and will be ignored"
            }

            $uri = "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/token"
            Write-Debug "POST $uri`n`n$(($body.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "`n&")"
            Invoke-RestMethod -Method Post -Uri $uri -Body $body -ErrorAction Stop
        }
    }
}