function Get-EntraIDAutomationAccountMSIAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile,

        [Parameter(Mandatory = $false, ParameterSetName = "resource")]
        [String] $Resource = $null
    )

    Process {       
        $body = @{
            'resource' = [String]::IsNullOrEmpty($Resource) ? $AccessTokenProfile.Resource : $Resource
        }

        if ($AccessTokenProfile.ClientId) {
            Write-Verbose "Getting access token for '$($body.resource)' using Automation Account User Assigned Identity with client_id $($AccessTokenProfile.ClientId)"
            $body['client_id'] = $AccessTokenProfile.ClientId
        }
        else {
            Write-Verbose "Getting access token for '$($body.resource)' using Automation Account System Assigned Identity"
        }
        
        Write-Debug "POST $($env:IDENTITY_ENDPOINT)`nMetadata: true`nX-IDENTITY-HEADER: $($env:IDENTITY_HEADER)`n`n$(($body.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "`n&")"
        Invoke-RestMethod -Uri $env:IDENTITY_ENDPOINT -Method 'POST' -Headers @{
            'Metadata'          = 'true'
            'X-IDENTITY-HEADER' = $env:IDENTITY_HEADER
        } -ContentType 'application/x-www-form-urlencoded' -Body $body       
    }
}