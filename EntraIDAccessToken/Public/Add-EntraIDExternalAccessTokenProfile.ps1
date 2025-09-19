<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDExternalAccessTokenProfile

#>
function Add-EntraIDExternalAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName = "string")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $true, ParameterSetName = "string")]
        [String] $AccessToken,

        [Parameter(Mandatory = $true, ParameterSetName = "securestring")]
        [SecureString] $SecureStringAccessToken
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        if( $PSCmdlet.ParameterSetName -eq "securestring") {
            $AccessToken = [pscredential]::new("123", $SecureStringAccessToken).GetNetworkCredential().Password
        }

        $Script:Profiles[$Name] = @{
            AuthenticationMethod = "externalaccesstoken"
            AccessToken          = $AccessToken
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
