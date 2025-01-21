function Get-EntraIDTrustingApplicationAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile,
        
        [Parameter(Mandatory = $true)]
        [String] $JWT,

        [Parameter(Mandatory = $false, ParameterSetName = "v1")]
        [NullString] $Resource = $null,

        [Parameter(Mandatory = $false, ParameterSetName = "v2")]
        [NullString] $Scope = $null
    )

    Process {
        if ($PSCmdlet.ParameterSetName -eq "v2") {
            Write-Verbose "Getting access token (v2) for trusting application with client_id $($ClientId) using MSI with client_id $($AccessTokenProfile.ClientId)"
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token" -Body @{
                client_id             = $AccessTokenProfile.TrustingApplicationClientId
                client_assertion      = $JWT
                scope                 = $Scope ?? $AccessTokenProfile.Scope
                grant_type            = "client_credentials"
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
            } -ErrorAction Stop
        }
        else {
            Write-Verbose "Getting access token (v1) for trusting application with client_id $($ClientId) using MSI with client_id $($AccessTokenProfile.ClientId)"
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/token" -Body @{
                client_id             = $AccessTokenProfile.TrustingApplicationClientId
                client_assertion      = $JWT
                resource              = $Resource ?? $AccessTokenProfile.Resource
                grant_type            = "client_credentials"
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
            } -ErrorAction Stop
        }        
    }
}