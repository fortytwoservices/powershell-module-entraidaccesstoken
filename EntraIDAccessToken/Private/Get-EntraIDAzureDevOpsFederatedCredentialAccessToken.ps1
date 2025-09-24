function Get-EntraIDAzureDevOpsFederatedCredentialAccessToken {
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
        $Example = '- task: AzureCLI@2
    displayName: Example task
    inputs:
        azureSubscription: example-service-connection
        scriptLocation: scriptPath
        scriptPath: "$(Build.SourcesDirectory)/Example.ps1"
        azurePowerShellVersion: "LatestVersion"
        scriptType: pscore
        addSpnToEnvironment: true
    env:
        SYSTEM_ACCESSTOKEN: $(System.AccessToken)'
        $OIDCToken = $ENV:idToken
        if ([String]::ISNullOrEmpty($ENV:SYSTEM_ACCESSTOKEN)) {
            Write-Warning "Please add SYSTEM_ACCESSTOKEN in order for Azure DevOps to work with Federated Workload Identity for long running tasks. `n`nExample task: `n$Example"
        }
        elseif ($ENV:SYSTEM_ACCESSTOKEN -notlike "ey*.ey*.*") {
            Write-Warning "Please add SYSTEM_ACCESSTOKEN in order for Azure DevOps to work with Federated Workload Identity for long running tasks. `n`nExample task: `n$Example"
        }
        elseif ([String]::ISNullOrEmpty($ENV:SYSTEM_OIDCREQUESTURI)) {
            Write-Warning "Please add 'addSpnToEnvironment: true' in order for Azure DevOps to work with Federated Workload Identity for long running tasks. `n`nExample task: `n$Example"
        }
        else {
            $Result = Invoke-RestMethod `
                -Uri "$($ENV:SYSTEM_OIDCREQUESTURI)?api-version=7.1&serviceConnectionId=$($ENV:AZURESUBSCRIPTION_SERVICE_CONNECTION_ID)" `
                -Method Post `
                -Headers @{
                Authorization  = "Bearer $ENV:SYSTEM_ACCESSTOKEN"
                'Content-Type' = 'application/json'
            }
            
            if ($Result.oidcToken -notlike "ey*.ey*.*") {
                throw "The OIDC token received from Azure DevOps does not appear to be valid."
            }
            else {
                $OIDCToken = $Result.oidcToken
            }
        }

        if ($Scope -or $AccessTokenProfile.Scope) {
            $body = @{
                client_id             = $AccessTokenProfile.ClientId
                scope                 = [String]::IsNullOrEmpty($Scope) ? $AccessTokenProfile.Scope: $Scope
                grant_type            = "client_credentials"
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                client_assertion      = $OIDCToken
            }

            Write-Verbose "Getting access token (v2/scope) for '$($body.scope)' using Azure DevOps Federated Workload Identity for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/v2.0/token" -Body $body
        }
        else {
            $body = @{
                client_id             = $AccessTokenProfile.ClientId
                resource              = [String]::IsNullOrEmpty($Resource) ? $AccessTokenProfile.Resource : $Resource
                grant_type            = "client_credentials"
                client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
                client_assertion      = $OIDCToken
            }
            
            Write-Verbose "Getting access token (v1/resource) for '$($body.resource)' using Azure DevOps Federated Workload Identity for client_id $($AccessTokenProfile.ClientId)"
        
            # Get token
            Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($AccessTokenProfile.TenantId)/oauth2/token" -Body $body -ErrorAction Stop
        }        
    }
}