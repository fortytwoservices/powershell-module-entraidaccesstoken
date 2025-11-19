# Inspiration: https://github.com/RamblingCookieMonster/PSStackExchange/blob/master/PSStackExchange/PSStackExchange.psm1

New-Variable -Scope Script -Name Profiles -Value @{}
New-Variable -Scope Script -Name ConfirmEntraIDAccessTokenJWKSCache -Value @{}

# Get public and private function definition files.
$Private = (Test-Path $PSScriptRoot\Private) ? @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue ) : @()
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue -Exclude *.Tests.ps1 )

# Dot source the files in order to define all cmdlets
Foreach ($import in @($Public + $Private)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename -Alias "GAT", "WAT", "GH", "GATSS"

# Check version
if ($GLOBAL:EntraIDAccessTokenVersionCheck -ne 'disabled' -and $ENV:EntraIDAccessTokenVersionCheck -ne 'disabled') {
    Write-Verbose "Checking for newer version..."
    try {
        $packages = Invoke-RestMethod "https://www.powershellgallery.com/api/v2/FindPackagesById()?id='EntraIDAccessToken'" -ErrorAction SilentlyContinue -OperationTimeoutSeconds 3
        $latestVersion = $packages.properties | 
        Where-Object id -eq 'EntraIDAccessToken' | 
        Where-Object version -like "*.*.*" | 
        ForEach-Object { [semver]$_.version } | 
        Sort-Object |
        Select-Object -Last 1

        Write-Verbose "Latest version on PSGallery: $latestVersion"

        $psd = Import-PowerShellDataFile "$PSScriptRoot/EntraIDAccessToken.psd1"
        Write-Verbose "Current module version: $($psd.ModuleVersion)"

        if ($latestVersion -gt [semver]$psd.ModuleVersion) {
            Write-Verbose "Newer version available"
            Write-Host "$($PSStyle.Foreground.BrightYellow)A newer version of the EntraIDAccessToken module is available. Current version: $($psd.ModuleVersion), New version: $($latestVersion). Please consider updating to the latest version from the PowerShell Gallery using the below cmdlet:`n`n    Update-Module EntraIDAccessToken`n`nThis check can be disabled by setting the environment variable `EntraIDAccessTokenVersionCheck` or the global variable `EntraIDAccessTokenVersionCheck` to 'disabled' before loading the module.$($PSStyle.Reset)"
        }
    }
    catch {
        Write-Verbose "Version check failed: $_"
    }
}