BeforeAll {
    $Script:Module = Import-Module ./EntraIDAccessToken -Force -PassThru
}

Describe "Add-EntraIDAzureVMMSIAccessTokenProfile.1" {
    BeforeAll {}

    It "Throws error when trying to use scope without a trusting application" {
        { Add-EntraIDAzureVMMSIAccessTokenProfile -Scope "https://graph.microsoft.com/.default" -TenantId "12345678-1234-1234-1234-123456789012" } | Should -Throw
    }
}

Describe "Add-EntraIDAzureVMMSIAccessTokenProfile.2" {
    BeforeAll {
        Mock -ModuleName $Script:Module.Name -CommandName Invoke-WebRequest -MockWith {
            return (@{
                access_token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.KMUFsIDTnFmyG3nMiGM6H9FNFUROf3wh7SmqJp-QV30"
                expires_in   = "3599"
                expires_on   = (Get-Date -Date (Get-Date).AddHours(1) -UFormat %s)
            }
            |ConvertTo-Json)
        }
    }

    It "Should return a mock token" {
        Add-EntraIDAzureVMMSIAccessTokenProfile

        Get-EntraIDAccessToken | Should -Be "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.KMUFsIDTnFmyG3nMiGM6H9FNFUROf3wh7SmqJp-QV30"
    }
}