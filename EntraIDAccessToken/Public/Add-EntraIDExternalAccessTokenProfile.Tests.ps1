BeforeAll {
    Import-Module ./EntraIDAccessToken -Force
}

Describe "Add-EntraIDExternalAccessTokenProfile.1" -Tag Mocked {
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

Describe "Add-EntraIDExternalAccessTokenProfile.2" -Tag Mocked {
    It "Accepts a valid access token as a secure string" {
        $Name = (New-Guid).ToString()
        $Orig = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.KMUFsIDTnFmyG3nMiGM6H9FNFUROf3wh7SmqJp-QV30"
        $AT = $Orig | ConvertTo-SecureString -AsPlainText -Force
        Add-EntraIDExternalAccessTokenProfile -Name $Name -SecureStringAccessToken $AT
        Get-EntraIDAccessToken -Profile $Name | Should -Be $Orig

        (Get-EntraIDAccessToken -Profile $Name | ConvertFrom-EntraIDAccessToken).Payload.sub | Should -Be "1234567890"
        (Get-EntraIDAccessToken -Profile $Name | ConvertFrom-EntraIDAccessToken).Payload.name | Should -Be "John Doe"
        (Get-EntraIDAccessToken -Profile $Name | ConvertFrom-EntraIDAccessToken).Payload.admin | Should -Be $true
        (Get-EntraIDAccessToken -Profile $Name | ConvertFrom-EntraIDAccessToken).Payload.iat | Should -Be 1516239022
    }
}


Describe "Add-EntraIDExternalAccessTokenProfile.3" -Tag Mocked {
    It "Accepts a valid access token from clipboard" {
        $JWT = New-DummyJWT
        $OldClipboardValue = Get-Clipboard
        Set-Clipboard -Value $JWT

        $Name = (New-Guid).ToString()
        { Add-EntraIDExternalAccessTokenProfile -Name $Name -Clipboard } | Should -Not -Throw
        Get-EntraIDAccessToken -Profile $Name | Should -Be $JWT

        # Restore clipboard...
        Set-Clipboard -Value $OldClipboardValue
    }

    It "Accepts a valid bearer header from clipboard" {
        $JWT = New-DummyJWT
        $OldClipboardValue = Get-Clipboard
        Set-Clipboard -Value "Bearer $JWT"

        $Name = (New-Guid).ToString()
        { Add-EntraIDExternalAccessTokenProfile -Name $Name -Clipboard } | Should -Not -Throw
        Get-EntraIDAccessToken -Profile $Name | Should -Be $JWT

        # Restore clipboard...
        Set-Clipboard -Value $OldClipboardValue
    }
}
