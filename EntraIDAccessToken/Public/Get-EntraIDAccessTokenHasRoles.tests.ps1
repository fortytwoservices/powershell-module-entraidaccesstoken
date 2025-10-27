BeforeAll {
    Import-Module ./EntraIDAccessToken -Force
}

Describe "Get-EntraIDAccessTokenHasRoles" -Tag "Unit" {
    BeforeAll {
        
    }

    It "Returns true when all of the roles are present" {
        New-DummyJWT -OtherClaims @{roles=@("user","group")} -Verbose |
        Get-EntraIDAccessTokenHasRoles -Roles "user", "group" |
        Should -Be $true
    }

    It "Returns true if one role is missing" {
        New-DummyJWT -OtherClaims @{roles=@("user","group")} -Verbose |
        Get-EntraIDAccessTokenHasRoles -Roles "user", "group", "admin" |
        Should -Be $false
    }

    It "Returns true when any of the roles are present" {
        New-DummyJWT -OtherClaims @{roles=@("user","group")} -Verbose |
        Get-EntraIDAccessTokenHasRoles -Roles "mail", "group" -Any |
        Should -Be $true
    }
}