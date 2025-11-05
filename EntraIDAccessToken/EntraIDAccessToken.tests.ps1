Describe "Test module loading" -Tag 'Loading' {
    It "Module imports without errors" {
        { Import-Module -Name "$PSScriptRoot/" -Force 6> $null } | Should -Not -Throw
    }
}

Describe "Test module loading" -Tag 'Loading' {
    BeforeAll {
        # Backup original psd1
        $psd1 = Get-Content -Path "$PSScriptRoot/EntraIDAccessToken.psd1"

        # Replace version to an older one to trigger update message
        $psd1 | ForEach-Object {
            if($_ -like "*ModuleVersion*") {
                "ModuleVersion = '0.0.1'"
            } else {
                $_
            }
        } | Set-Content -Path "$PSScriptRoot/EntraIDAccessToken.psd1"
    }

    It "Module imports with an output about a new version" {
        $ENV:EntraIDAccessTokenVersionCheck = $null
        $Global:EntraIDAccessTokenVersionCheck = $null
        Import-Module -Name "$PSScriptRoot/" -Force 6>&1 | Should -BeLike "*A newer version of the EntraIDAccessToken module is available*"
    }

    It "Module imports withoutput version check, if env is set" {
        $Global:EntraIDAccessTokenVersionCheck = $null
        $ENV:EntraIDAccessTokenVersionCheck = 'disabled'
        Import-Module -Name "$PSScriptRoot/" -Force 6>&1 | Should -Not -BeLike "*A newer version of the EntraIDAccessToken module is available*"
    }

    It "Module imports withoutput version check, if global variable is set" {
        $ENV:EntraIDAccessTokenVersionCheck = $null
        $Global:EntraIDAccessTokenVersionCheck = 'disabled'
        Import-Module -Name "$PSScriptRoot/" -Force 6>&1 | Should -Not -BeLike "*A newer version of the EntraIDAccessToken module is available*"
    }

    AfterAll {
        # Restore original psd1
        $psd1 | Set-Content -Path "$PSScriptRoot/EntraIDAccessToken.psd1"
    }
}