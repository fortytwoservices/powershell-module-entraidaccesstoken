function Get-EntraIDAzureVMMSIAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile,

        [Parameter(Mandatory = $false, ParameterSetName = "resource")]
        [String] $Resource = $null
    )

    Process {       
        # TODO: Understand why documentation is pointing to http://localhost:50342/oauth2/token - https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-to-use-vm-sign-in
        $uri = "http://169.254.169.254/metadata/identity/oauth2/token"

        $_resource = [String]::IsNullOrEmpty($Resource) ? $AccessTokenProfile.Resource : $Resource
        $response = Invoke-WebRequest -Uri "$($uri)?resource=$([System.Uri]::EscapeDataString($_resource))&api-version=2018-02-01" -Headers @{Metadata = "true" } -UseBasicParsing

        if ($response.StatusCode -ne 200) {
            throw "Error getting access token from Azure VM MSI endpoint: $($response.StatusCode) $($response.StatusDescription) $($response.Content)"
        }

        ConvertFrom-Json $response.Content  
    }
}