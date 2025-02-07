<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDAccessTokenProfile

#>
function Add-EntraIDAzurePowerShellSessionTokenProfile {
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $false)]
        [String] $Resource = "https://graph.microsoft.com"
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        $_TEMP = Get-AzAccessToken -ResourceUrl $Resource -AsSecureString

        $Script:Profiles[$Name] = @{
            AuthenticationMethod                    = "azurepowershellsession"
            ClientId                                = $_TEMP.UserId
            Resource                                = $Resource
            TenantId                                = $_TEMP.TenantId
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
