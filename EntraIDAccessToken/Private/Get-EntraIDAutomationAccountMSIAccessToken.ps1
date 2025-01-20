function Get-EntraIDAutomationAccountMSIAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $Profile,

        [Parameter(Mandatory = $false, ParameterSetName = "v1")]
        [String] $Resource = $null
    )

    Process {       
        $body = @{
            'resource' = $Resource ?? $Profile.Resource
        }

        if ($Profile.ClientId) {
            Write-Verbose "Getting access token for '$($body.resource)' using Automation Account User Assigned Identity with client_id $($Profile.ClientId)"
            $body['client_id'] = $Profile.ClientId
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