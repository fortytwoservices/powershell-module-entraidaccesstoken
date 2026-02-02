<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDFederatedCredentialTokenProfile

#>
function Add-EntraIDFederatedCredentialTokenProfile {
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
        [String] $FederatedAccessTokenProfile,

        [Parameter(Mandatory = $false)]
        [Switch] $AgentIdentity,

        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        if (!$Script:Profiles.ContainsKey($FederatedAccessTokenProfile)) {
            Write-Error "Federated access token profile $FederatedAccessTokenProfile does not exist"
            return
        }

        Add-EntraIDAccessTokenProfile -Name $Name -Profile @{
            AuthenticationMethod        = "federatedcredential"
            ClientId                    = $ClientId
            ClientSecret                = $ClientSecret
            Resource                    = $PSCmdlet.ParameterSetName -eq "resource" ? $Resource : $null
            Scope                       = $PSCmdlet.ParameterSetName -eq "scope" ? $Scope : $null
            TenantId                    = $TenantId
            FederatedAccessTokenProfile = $FederatedAccessTokenProfile
            AgentIdentity              = $AgentIdentity.IsPresent ? $true : $false
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
