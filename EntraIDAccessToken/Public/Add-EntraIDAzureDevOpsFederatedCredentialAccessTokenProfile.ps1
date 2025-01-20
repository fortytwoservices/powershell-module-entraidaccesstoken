<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDAccessTokenProfile

#>
function Add-EntraIDAzureDevOpsFederatedCredentialAccessTokenProfile {
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Profile = "Default",

        [Parameter(Mandatory = $false)]
        [String] $Resource = "https://graph.microsoft.com",

        [Parameter(Mandatory = $false)]
        [String] $Scope = "https://graph.microsoft.com/.default",

        [Parameter(Mandatory = $true)]
        [String] $TenantId,

        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId,

        # Specifies that we want a V2 token
        [Parameter(Mandatory = $true, ParameterSetName = "v2")]
        [Switch] $V2Token
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Profile)) {
            Write-Warning "Profile $Profile already exists, overwriting"
        }

        $Script:Profiles[$Profile] = @{
            AuthenticationMethod        = "azuredevopsfederatedcredential"
            ClientId                    = $ClientId
            Resource                    = $Resource
            TenantId                    = $TenantId
            Scope                       = $Scope
            V2Token                     = $V2Token.IsPresent ? $true : $false
        }

        Get-EntraIDAccessToken -Profile $Profile | Out-Null
    }
}
