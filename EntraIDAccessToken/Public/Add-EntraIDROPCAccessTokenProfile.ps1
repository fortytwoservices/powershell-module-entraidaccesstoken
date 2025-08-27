<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens using the Resource Owner Password Credentials (ROPC) flow.

.EXAMPLE
Add-EntraIDROPCAccessTokenProfile.ps1

#>
function Add-EntraIDROPCAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName="default")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $false)]
        [String] $Scope = "https://graph.microsoft.com/.default offline_access",

        [Parameter(Mandatory = $true)]
        [String] $TenantId,

        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId,

        [Parameter(Mandatory = $true)]
        [SecureString] $ClientSecret,

        [Parameter(Mandatory = $true)]
        [PSCredential] $UserCredential
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        $Script:Profiles[$Name] = @{
            AuthenticationMethod = "ropc"
            TenantId             = $TenantId
            ClientId             = $ClientId
            Scope                = $Scope
            ClientSecret         = $ClientSecret
            UserCredential       = $UserCredential
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
