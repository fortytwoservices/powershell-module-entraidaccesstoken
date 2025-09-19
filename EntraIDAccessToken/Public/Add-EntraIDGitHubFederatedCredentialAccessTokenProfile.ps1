<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDGitHubFederatedCredentialAccessTokenProfile

#>
function Add-EntraIDGitHubFederatedCredentialAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName = "scope")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $false, ParameterSetName = "resource")]
        [String] $Resource = "https://graph.microsoft.com",

        [Parameter(Mandatory = $false, ParameterSetName = "scope")]
        [String] $Scope = "https://graph.microsoft.com/.default",

        [Parameter(Mandatory = $true)]
        [String] $TenantId,

        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId,

        # Specifies that we want a V2 token
        [Parameter(Mandatory = $false, ParameterSetName = "v2")]
        [Switch] $V2Token
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey("V2Token")) {
            Write-Warning "The V2Token parameter is deprecated and will be removed in a future release. The presence of a Scope parameter now implies a V2 token."
        }

        $Script:Profiles[$Name] = @{
            AuthenticationMethod = "githubfederatedcredential"
            ClientId             = $ClientId
            Resource             = $PSCmdlet.ParameterSetName -eq "resource" ? $Resource : $null
            Scope                = $PSCmdlet.ParameterSetName -eq "scope" ? $Scope : $null
            TenantId             = $TenantId
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
