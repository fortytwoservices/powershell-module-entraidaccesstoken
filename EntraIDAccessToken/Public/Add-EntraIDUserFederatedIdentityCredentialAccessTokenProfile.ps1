<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

#>
function Add-EntraIDUserFederatedIdentityCredentialAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName = "scope_userid")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $false, ParameterSetName = "scope_userid")]
        [Parameter(Mandatory = $false, ParameterSetName = "scope_username")]
        [ValidateScript({ [string]::IsNullOrEmpty($_) -eq $false })]
        [String] $Scope = "https://graph.microsoft.com/.default",

        [Parameter(Mandatory = $true)]
        [String] $TenantId,

        [Parameter(Mandatory = $true)]
        [String] $ClientAssertionProfile,

        [Parameter(Mandatory = $true)]
        [String] $UserFederatedIdentityCredentialProfile,

        [Parameter(Mandatory = $true, ParameterSetName = "scope_userid")]
        [String] $UserId,

        [Parameter(Mandatory = $true, ParameterSetName = "scope_username")]
        [String] $Username,

        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId
    )
    
    Process {
        if (!$Script:Profiles.ContainsKey($ClientAssertionProfile)) {
            throw "Profile $ClientAssertionProfile does not exist"
        }

        if (!$Script:Profiles.ContainsKey($UserFederatedIdentityCredentialProfile)) {
            throw "Profile $UserFederatedIdentityCredentialProfile does not exist"
        }

        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        $Script:Profiles[$Name] = @{
            AuthenticationMethod                   = "userfederatedidentitycredential"
            Scope                                  = $Scope
            ClientAssertionProfile                 = $ClientAssertionProfile
            UserFederatedIdentityCredentialProfile = $UserFederatedIdentityCredentialProfile
            UserId                                 = $PSCmdlet.ParameterSetName -eq "scope_userid" ? $UserId : $null
            Username                               = $PSCmdlet.ParameterSetName -eq "scope_username" ? $Username : $null
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
