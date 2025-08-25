function Get-EntraIDAzureArcManagedMSIAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile,

        [Parameter(Mandatory = $false, ParameterSetName = "v1")]
        [String] $Resource = $null
    )

    Process {       
        $uri = "$($env:IDENTITY_ENDPOINT)?api-version=2020-06-01"

        # Add resource
        $_Resource = [String]::IsNullOrEmpty($Resource) ? $AccessTokenProfile.Resource : $Resource
        $uri = "{0}&resource={1}" -f $uri, [System.Uri]::EscapeUriString($_Resource)

        # Add client_id
        if ($AccessTokenProfile.ClientId) {
            Write-Verbose "Getting access token for '$($body.resource)' using Azure Arc Managed Identity with client_id $($AccessTokenProfile.ClientId)"
            $uri = "{0}&client_id={1}" -f $uri, $AccessTokenProfile.ClientId
        }
        else {
            Write-Verbose "Getting access token for '$($body.resource)' using Azure Arc Managed Identity"
        } 

        try {
            $result = Invoke-WebRequest -Method GET -Uri $uri -Headers @{Metadata = 'True' } -UseBasicParsing
            return ($result.Content | ConvertFrom-Json -Depth 10)
        }
        catch {
            $wwwAuthHeader = $_.Exception.Response.Headers["WWW-Authenticate"]
            if ($wwwAuthHeader -match "Basic realm=.+") {
                $secret = ($wwwAuthHeader -split "Basic realm=")[1]
            }

            $response = Invoke-WebRequest -Method GET -Uri $uri -Headers @{Metadata = 'True'; Authorization = "Basic $secret" } -UseBasicParsing
            ConvertFrom-Json -InputObject $response.Content
        }
    }
}