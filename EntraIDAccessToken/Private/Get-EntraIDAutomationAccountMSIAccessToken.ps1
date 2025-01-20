function Get-EntraIDAutomationAccountMSIAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile,

        [Parameter(Mandatory = $false, ParameterSetName = "v1")]
        [String] $Resource = $null
    )

    Process {       
        $body = @{
            'resource' = $Resource ?? $AccessTokenProfile.Resource
        }

        if ($AccessTokenProfile.ClientId) {
            Write-Verbose "Getting access token for '$($body.resource)' using Automation Account User Assigned Identity with client_id $($AccessTokenProfile.ClientId)"
            $body['client_id'] = $AccessTokenProfile.ClientId
        }
        else {
            Write-Verbose "Getting access token for '$($body.resource)' using Automation Account System Assigned Identity"
        }
            
        Invoke-RestMethod $env:IDENTITY_ENDPOINT -Method 'POST' -Headers @{
            'Metadata'          = 'true'
            'X-IDENTITY-HEADER' = $env:IDENTITY_HEADER
        } -ContentType 'application/x-www-form-urlencoded' -Body $body       
    }
}