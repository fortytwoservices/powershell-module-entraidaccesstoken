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
        [SecureString] $SecureStringAccessToken,

        [Parameter(Mandatory = $true, ParameterSetName = "clipboard")]
        [Switch] $Clipboard
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        if( $PSCmdlet.ParameterSetName -eq "securestring") {
            $AccessToken = [pscredential]::new("123", $SecureStringAccessToken).GetNetworkCredential().Password
        }

        if( $PSCmdlet.ParameterSetName -eq "clipboard" -and $Clipboard.IsPresent) {
            $_Clipboard = Get-Clipboard
            if($_Clipboard -like "Bearer *") {
                $_Clipboard = $_Clipboard.Substring(7)
            }

            if($_Clipboard -like "ey*.ey*.*") {
                $AccessToken = $_Clipboard
            }
            else {
                Write-Error "Clipboard does not contain a valid access token"
            }
        }

        $Script:Profiles[$Name] = @{
            AuthenticationMethod = "externalaccesstoken"
            AccessToken          = $AccessToken
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
