<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDAgentUserTokenProfile

#>
function Add-EntraIDAgentUserTokenProfile {
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $false)]
        [String] $Scope = "https://graph.microsoft.com/.default",

        [Parameter(Mandatory = $true)]
        [String] $AgentIdentityAccessTokenProfile,

        [Parameter(Mandatory = $true)]
        [String] $UserPrincipalName
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        if (!$Script:Profiles.ContainsKey($AgentIdentityAccessTokenProfile)) {
            Write-Error "Agent identity access token profile $AgentIdentityAccessTokenProfile does not exist"
            return
        }

        if (!$Script:Profiles[$AgentIdentityAccessTokenProfile].AgentIdentity) {
            Write-Error "Access token profile $AgentIdentityAccessTokenProfile is not configured for agent identity"
            return
        }

        if ($Script:Profiles[$AgentIdentityAccessTokenProfile].Scope -ne "api://AzureADTokenExchange/.default") {
            Write-Error "Access token profile $AgentIdentityAccessTokenProfile is not configured for scope 'api://AzureADTokenExchange/.default'"
            return
        }

        Add-EntraIDAccessTokenProfile -Name $Name -Profile @{
            AuthenticationMethod            = "agentuser"
            UserPrincipalName              = $UserPrincipalName
            Scope                           = $Scope
            AgentIdentityAccessTokenProfile = $AgentIdentityAccessTokenProfile
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
