function Get-EntraIDTrustingApplicationAccessToken {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $true)]
        $Profile,
        
        [Parameter(Mandatory = $true)]
        [String] $JWT,

        [Parameter(Mandatory = $false, ParameterSetName = "v1")]
        [String] $Resource = $null,

        [Parameter(Mandatory = $false, ParameterSetName = "v2")]
        [String] $Scope = $null
    )

    Process {
        if ($PSCmdlet.ParameterSetName -eq "v2") {
            Write-Verbose "Getting access token (v2) for trusting application with client_id $($ClientId) using MSI with client_id $($Profile.ClientId)"
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($Profile.TenantId)/oauth2/v2.0/token" -Body @{
                client_id             = $Profile.TrustingApplicationClientId
                client_assertion      = $JWT
                scope                 = $Scope ?? $Profile.Scope
                grant_type            = "client_credentials"
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
            } -ErrorAction Stop
        }
        else {
            Write-Verbose "Getting access token (v1) for trusting application with client_id $($ClientId) using MSI with client_id $($Profile.ClientId)"
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($Profile.TenantId)/oauth2/token" -Body @{
                client_id             = $Profile.TrustingApplicationClientId
                client_assertion      = $JWT
                scope                 = $Scope ?? $Profile.Scope
                grant_type            = "client_credentials"
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
            } -ErrorAction Stop
        }        
    }
}