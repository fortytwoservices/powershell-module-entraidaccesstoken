Describe "Get-EntraIDAccessTokenHeader" -Tag Mocked {
    It "Throws an error for a non-existing profile" {
        { Get-EntraIDAccessTokenHeader -Profile "NonExistingProfile" } | Should -Throw "Profile NonExistingProfile does not exist"
    }

    It "Returns a valid header foran existing profile" {
        # Arrange
        $testProfileName = "TestProfile"
        $testToken = New-DummyJWT
        Add-EntraIDExternalAccessTokenProfile -Name $testProfileName -AccessToken $testToken
        { Get-EntraIDAccessTokenHeader -Profile $testProfileName } | Should -Not -Throw
        (Get-EntraIDAccessTokenHeader -Profile $testProfileName).Authorization | Should -Be "Bearer $testToken"
        (Get-EntraIDAccessTokenHeader -Profile $testProfileName -AdditionalHeaders @{test="OK"}).Authorization | Should -Be "Bearer $testToken"
        (Get-EntraIDAccessTokenHeader -Profile $testProfileName -AdditionalHeaders @{test="OK"}).test | Should -Be "OK"
    }
}