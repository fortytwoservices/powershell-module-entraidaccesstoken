BeforeAll {
    Import-Module ./EntraIDAccessToken -Force
}

Describe "Get-EntraIDAccessTokenType" -Tag "Unit" {
    BeforeAll {
        
    }

    It "Returns user when the access token is for a user" {
        New-DummyJWT -OtherClaims @{idtyp="user"} -Verbose |
        Get-EntraIDAccessTokenType | 
        Should -Be "user"
    }

    It "Returns app when the access token is for an app" {
        New-DummyJWT -Verbose |
        Get-EntraIDAccessTokenType | 
        Should -Be "app"
    }
}