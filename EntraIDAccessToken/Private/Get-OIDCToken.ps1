<#
.Synopsis
    Gets a OIDC token to replace $ENV:idToken
.DESCRIPTION
    Gets a OIDC token to replace $ENV:idToken
.EXAMPLE
    Get-OIDCToken
#>
function Get-OIDCToken {
    [CmdletBinding()]
 
    param () 
 
    Process {
        Invoke-RestMethod `
            -Uri "$($ENV:SYSTEM_OIDCREQUESTURI)?api-version=7.1&serviceConnectionId=$ENV:AZURESUBSCRIPTION_SERVICE_CONNECTION_ID" `
            -Method Post `
            -Headers @{
                Authorization  = "Bearer $ENV:SYSTEM_ACCESSTOKEN"
                'Content-Type' = 'application/json'
            } | Select-Object -ExpandProperty oidcToken
    }
}