function Add-EntraIDFederatedTokenFileAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName = "scope")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $false, ParameterSetName = "scope")]
        [String] $Scope = "https://graph.microsoft.com/.default",

        [Parameter(Mandatory = $true)]
        [String] $TenantId,
        
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [String] $File,

        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        Add-EntraIDAccessTokenProfile -Name $Name -Profile @{
            AuthenticationMethod                    = "federatedtokenfile"
            ClientId                                = $ClientId
            File                                    = $File
            Scope                                   = $Scope
            TenantId                                = $TenantId
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
