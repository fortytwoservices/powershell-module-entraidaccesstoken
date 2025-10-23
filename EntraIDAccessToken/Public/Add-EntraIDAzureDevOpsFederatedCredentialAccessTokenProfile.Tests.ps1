BeforeAll {
    Import-Module ./EntraIDAccessToken -Force
    $env:idToken = $null
}

Describe "Add-EntraIDAzureDevOpsFederatedCredentialAccessTokenProfile.1" {
    It "Throws error when no idToken environment variable is present" {
        {
            $env:idToken = $null
            Add-EntraIDAzureDevOpsFederatedCredentialAccessTokenProfile -TenantId "72f988bf-86f1-41af-91ab-2d7cd011db47" -WarningAction SilentlyContinue
        } | Should -Throw
    }

    It "Throws error when no tenantid is provided" {
        {
            Add-EntraIDAzureDevOpsFederatedCredentialAccessTokenProfile -WarningAction SilentlyContinue
        } | Should -Throw
    }

    It "Gets error when idToken env variable is invalid" {
        $Error.Clear()
        $env:idToken = "invalid"
        Add-EntraIDAzureDevOpsFederatedCredentialAccessTokenProfile -TenantId "72f988bf-86f1-41af-91ab-2d7cd011db47" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue

        $Error[0].Exception.Message | Should -BeLike "*AADSTS50027*"
    }
}