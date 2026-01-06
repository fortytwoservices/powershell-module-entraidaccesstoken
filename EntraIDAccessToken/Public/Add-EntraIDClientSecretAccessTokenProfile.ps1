<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDAccessTokenProfile

#>
function Add-EntraIDClientSecretAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName = "resource")]

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
        [securestring] $ClientSecret,

        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId,

        # Specifies that we want a V2 token
        [Parameter(Mandatory = $false, ParameterSetName = "scope")]
        [Switch] $V2Token,

        [Parameter(Mandatory = $false, ParameterSetName = "scope")]
        [String] $FMIPath
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey("V2Token")) {
            Write-Warning "The V2Token parameter is deprecated and will be removed in a future release. The presence of a Scope parameter now implies a V2 token."
        }

        $Script:Profiles[$Name] = @{
            AuthenticationMethod = "clientsecret"
            ClientId             = $ClientId
            ClientSecret         = $ClientSecret
            Resource             = $PSCmdlet.ParameterSetName -eq "resource" ? $Resource : $null
            Scope                = $PSCmdlet.ParameterSetName -eq "scope" ? $Scope : $null
            TenantId             = $TenantId
            FMIPath              = $PSCmdlet.MyInvocation.BoundParameters.ContainsKey("FMIPath") ? $FMIPath : $null
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
