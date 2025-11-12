BeforeAll {
    $Script:Module = Import-Module -Name "$PSScriptRoot/../" -Force -PassThru
}

Describe "Write-EntraIDAccessToken" -Tag Mocked {
    It "Should not throw when valid access token is sent" {
        { New-DummyJWT | Write-EntraIDAccessToken } | Should -Not -Throw
    }

    It "Should not throw when valid access token header is piped in" {
        { @{Authorization = "bearer $(New-DummyJWT)" } | Write-EntraIDAccessToken } | Should -Not -Throw
    }

    It "Should not throw when valid access token with 'Bearer' casing is sent" {
        { "Bearer $(New-DummyJWT)" | Write-EntraIDAccessToken } | Should -Not -Throw
    }

    It "Should throw when invalid access token is sent" {
        { "invalid_token" | Write-EntraIDAccessToken } | Should -Throw
    }
}