<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDAccessTokenProfile

#>
function Add-EntraIDClientSecretAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName = "v1")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $false, ParameterSetName = "v1")]
        [String] $Resource = "https://graph.microsoft.com",

        [Parameter(Mandatory = $false, ParameterSetName = "v2")]
        [String] $Scope = "https://graph.microsoft.com/.default",

        [Parameter(Mandatory = $true)]
        [String] $TenantId,

        [Parameter(Mandatory = $true)]
        [securestring] $ClientSecret,

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

        $Script:Profiles[$Name] = @{
            AuthenticationMethod                    = "clientsecret"
            ClientId                                = $ClientId
            ClientSecret                            = $ClientSecret
            Resource                                = $Resource
            Scope                                   = $Scope
            TenantId                                = $TenantId
            V2Token                                 = $V2Token.IsPresent ? $true : $false
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
