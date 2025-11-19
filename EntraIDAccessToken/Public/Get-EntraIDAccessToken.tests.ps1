Describe "Get-EntraIDAccessToken" -Tag Mocked {
    It "Throws an error for a non-existing profile" {
        { Get-EntraIDAccessToken -Profile "NonExistingProfile" } | Should -Throw "Profile NonExistingProfile does not exist"
    }

    It "Returns a token for an existing profile" {
        # Arrange
        $testProfileName = "TestProfile"
        $testToken = New-DummyJWT
        Add-EntraIDExternalAccessTokenProfile -Name $testProfileName -AccessToken $testToken
        { Get-EntraIDAccessToken -Profile $testProfileName } | Should -Not -Throw
        Get-EntraIDAccessToken -Profile $testProfileName | Should -Be $testToken
    }
}