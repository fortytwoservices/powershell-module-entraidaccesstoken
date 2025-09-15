BeforeAll {
    Import-Module ./EntraIDAccessToken -Force
}

Describe "Add-EntraIDExternalAccessTokenProfile" {
    It "Accepts a valid access token" {
        $Name = (New-Guid).ToString()
        $AT = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.KMUFsIDTnFmyG3nMiGM6H9FNFUROf3wh7SmqJp-QV30"
        Add-EntraIDExternalAccessTokenProfile -Name $Name -AccessToken $AT
        Get-EntraIDAccessToken -Profile $Name | Should -Be $AT

        (Get-EntraIDAccessToken -Profile $Name | ConvertFrom-EntraIDAccessToken).Payload.sub | Should -Be "1234567890"
        (Get-EntraIDAccessToken -Profile $Name | ConvertFrom-EntraIDAccessToken).Payload.name | Should -Be "John Doe"
        (Get-EntraIDAccessToken -Profile $Name | ConvertFrom-EntraIDAccessToken).Payload.admin | Should -Be $true
        (Get-EntraIDAccessToken -Profile $Name | ConvertFrom-EntraIDAccessToken).Payload.iat | Should -Be 1516239022
    }
}