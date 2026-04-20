Describe "Test module loading" -Tag 'Loading' {
    It "Module imports without errors" {
        { Import-Module -Name "$PSScriptRoot/" -Force 6> $null } | Should -Not -Throw
    }
}