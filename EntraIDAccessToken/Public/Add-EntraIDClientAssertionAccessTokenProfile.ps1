<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDAccessTokenProfile

#>
function Add-EntraIDClientAssertionAccessTokenProfile {
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
        [String] $ClientAssertionProfile,

        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId
    )
    
    Process {
        if (!$Script:Profiles.ContainsKey($ClientAssertionProfile)) {
            throw "Profile $ClientAssertionProfile does not exist"
        }

        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        $Script:Profiles[$Name] = @{
            AuthenticationMethod   = "clientassertion"
            ClientId               = $ClientId
            Resource               = $PSCmdlet.ParameterSetName -eq "resource" ? $Resource : $null
            Scope                  = $PSCmdlet.ParameterSetName -eq "scope" ? $Scope : $null
            TenantId               = $TenantId
            ClientAssertionProfile = $ClientAssertionProfile
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
