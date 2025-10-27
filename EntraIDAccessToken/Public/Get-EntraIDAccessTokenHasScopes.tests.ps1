BeforeAll {
    Import-Module ./EntraIDAccessToken -Force
}

Describe "Get-EntraIDAccessTokenHasScopes" -Tag "Unit" {
    BeforeAll {
        
    }

    It "Returns true when all of the scopes are present" {
        New-DummyJWT -OtherClaims @{scp="user.read group.read"} -Verbose |
        Get-EntraIDAccessTokenHasScopes -Scopes "user.read", "group.read" |
        Should -Be $true
    }
    
    It "Returns true if one scope is missing" {
        New-DummyJWT -OtherClaims @{scp="user.read group.read"} -Verbose |
        Get-EntraIDAccessTokenHasScopes -Scopes "user.read", "group.read", "mail.read" |
        Should -Be $false
    }

    It "Returns true when any of the scopes are present" {
        New-DummyJWT -OtherClaims @{scp="user.read group.read"} -Verbose |
        Get-EntraIDAccessTokenHasScopes -Scopes "mail.read", "group.read" -Any |
        Should -Be $true
    }
}