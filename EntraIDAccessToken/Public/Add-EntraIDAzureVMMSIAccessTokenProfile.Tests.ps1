BeforeAll {
    Import-Module ./EntraIDAccessToken -Force
}

Describe "Add-EntraIDAzureVMMSIAccessTokenProfile.1" {
    BeforeAll {}

    It "Throws error when trying to use scope without a trusting application" {
        { Add-EntraIDAzureVMMSIAccessTokenProfile -Scope "https://graph.microsoft.com/.default" -TenantId "12345678-1234-1234-1234-123456789012" } | Should -Throw
    }
}