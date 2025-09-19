function Get-EntraIDGitHubFederatedCredentialAccessToken {
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
        $Url = "{0}&audience={1}" -f $ENV:ACTIONS_ID_TOKEN_REQUEST_URL, "api://AzureADTokenExchange"
        Write-Verbose "Getting token exchange access token from $Url"
        $GitHubJWT = Invoke-RestMethod $Url -Headers @{Authorization = ("bearer {0}" -f $ENV:ACTIONS_ID_TOKEN_REQUEST_TOKEN) }

        if (!$GitHubJWT.Value) {
            Write-Error "Failed to get GitHub JWT"
            return
        }

        Get-EntraIDFederatedCredentialAccessToken -AccessTokenProfile $AccessTokenProfile -JWT $GitHubJWT.Value -ClientId $AccessTokenProfile.ClientId
    }
}