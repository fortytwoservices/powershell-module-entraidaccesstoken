function Get-EntraIDFunctionAppMSIAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile,

        [Parameter(Mandatory = $false, ParameterSetName = "v1")]
        [String] $Resource = $null
    )

    Process {       
        $uri = "$($env:IDENTITY_ENDPOINT)?api-version=2019-08-01"

        # Add resource
        $_Resource = [String]::IsNullOrEmpty($Resource) ? $AccessTokenProfile.Resource : $Resource
        $uri = "{0}&resource={1}" -f $uri, [System.Uri]::EscapeUriString($_Resource)

        # Add client_id
        if ($AccessTokenProfile.ClientId) {
            Write-Verbose "Getting access token for '$($body.resource)' using Function App User Assigned Identity with client_id $($AccessTokenProfile.ClientId)"
            $uri = "{0}&client_id={1}" -f $uri, $AccessTokenProfile.ClientId
        }
        else {
            Write-Verbose "Getting access token for '$($body.resource)' using Function App System Assigned Identity"
        }
            
        Invoke-RestMethod $uri -Method 'GET' -Headers @{
            'X-IDENTITY-HEADER' = $env:IDENTITY_HEADER
        }    
    }
}