function Get-EntraIDAzurePowerShellSessionAccessToken {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $AccessTokenProfile
    )

    Process {
        $_TEMP = Get-AzAccessToken -ResourceUrl $AccessTokenProfile.Resource -AsSecureString
        
        @{
            access_token = [PSCredential]::new("...", $_TEMP.Token).GetNetworkCredential().Password
            expires_in = [int] $_TEMP.ExpiresOn.Subtract((Get-Date)).TotalSeconds
        }
    }
}