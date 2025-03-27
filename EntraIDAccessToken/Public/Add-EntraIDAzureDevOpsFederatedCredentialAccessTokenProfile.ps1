<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDAccessTokenProfile

#>
function Add-EntraIDAzureDevOpsFederatedCredentialAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName="Default")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [String] $Resource = "https://graph.microsoft.com",

        [Parameter(Mandatory = $false, ParameterSetName = "v2")]
        [String] $Scope = "https://graph.microsoft.com/.default",

        [Parameter(Mandatory = $false)]
        [String] $TenantId = $ENV:AZURESUBSCRIPTION_TENANT_ID,

        [Parameter(Mandatory = $false)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId = $ENV:AZURESUBSCRIPTION_CLIENT_ID,

        # Specifies that we want a V2 token
        [Parameter(Mandatory = $true, ParameterSetName = "v2")]
        [Switch] $V2Token,
    
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [Parameter(Mandatory = $false, ParameterSetName = "v2")]
        [Switch] $UseOIDCRequestUri
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        $Script:Profiles[$Name] = @{
            AuthenticationMethod        = "azuredevopsfederatedcredential"
            ClientId                    = $ClientId
            Resource                    = $Resource
            TenantId                    = $TenantId
            Scope                       = $Scope
            V2Token                     = $V2Token.IsPresent ? $true : $false
            OIDCRequestUri              = $UseOIDCRequestUri.IsPresent ? $true : $false
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
