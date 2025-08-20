<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDInteractiveUserAccessTokenProfile

#>
function Add-EntraIDInteractiveUserAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName="clientsecret")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $false)]
        [String] $Scope = "https://graph.microsoft.com/.default offline_access",

        [Parameter(Mandatory = $false)]
        [String] $TenantId = "common",

        [Parameter(Mandatory = $false)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId = "14d82eec-204b-4c2f-b7e8-296a70dab67e",

        [Parameter(Mandatory = $false)]
        [ValidateRange(1024, 65535)]
        [int] $LocalhostPort = -1,

        [Parameter(Mandatory = $false)]
        [bool] $Https = $false,

        [Parameter(Mandatory = $false)]
        [bool] $LaunchBrowser = $true
    )
    
    Process {
        if($LocalhostPort -eq -1) {
            $LocalhostPort = Get-Random -Minimum 1024 -Maximum 65535
        }
        
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        $Script:Profiles[$Name] = @{
            AuthenticationMethod = "interactiveuser"
            TenantId             = $TenantId
            ClientId             = $ClientId
            Scope                = $Scope
            LocalhostPort        = $LocalhostPort
            Https                = $Https
            LaunchBrowser        = $LaunchBrowser
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
