<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDInteractiveUserAccessTokenProfile

#>
function Add-EntraIDInteractiveUserAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName = "clientid")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $false)]
        [String] $Scope = "https://graph.microsoft.com/.default offline_access",

        [Parameter(Mandatory = $false)]
        [String] $TenantId = "common",

        [Parameter(Mandatory = $false, ParameterSetName = "clientid")]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId = "14d82eec-204b-4c2f-b7e8-296a70dab67e",

        [Parameter(Mandatory = $true, ParameterSetName = "wellknownclientid")]
        [ValidateSet("Microsoft Graph PowerShell", "Azure CLI", "Azure PowerShell")]
        [String] $WellKnownClientId,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1024, 65535)]
        [int] $LocalhostPort = -1,

        [Parameter(Mandatory = $false)]
        [bool] $Https = $false,

        [Parameter(Mandatory = $false)]
        [bool] $LaunchBrowser = $true
    )
    
    Process {
        if ($LocalhostPort -eq -1) {
            $LocalhostPort = Get-Random -Minimum 1024 -Maximum 65535
        }
        
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        if ($PSCmdlet.ParameterSetName -eq "wellknownclientid") {
            switch ($WellKnownClientId) {
                "Microsoft Graph PowerShell" { $ClientId = "14d82eec-204b-4c2f-b7e8-296a70dab67e" }
                "Azure CLI" { $ClientId = "04b07795-8ddb-461a-bbee-02f9e1bf7b46" }
                "Azure PowerShell" { $ClientId = "1950a258-227b-4e31-a9cf-717495945fc2" }
            }
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
