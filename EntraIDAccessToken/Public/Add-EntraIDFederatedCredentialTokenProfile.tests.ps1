BeforeAll {
    $Script:Module = Import-Module "$PSScriptRoot/../" -Force -PassThru

    $Script:TenantId = "12345678-1234-1234-1234-123456789012"
    $Script:ClientIdForCredItself = "98fe3f87-d6ce-43b7-96d1-ddd2eb4fd2f1"
    $Script:ClientIdWithFedCred = "bb3d51a9-8f6e-4f51-b52b-9c284bfe3120"
}

Describe "Add-EntraIDFederatedCredentialTokenProfile.1" -Tag Mocked, Dev {
    BeforeAll {
        Mock -ModuleName $Script:Module.Name -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like "https://login.microsoftonline.com/$($Script:TenantId)/oauth2/v2.0/token" } -MockWith {
            Write-Verbose "Mocked Invoke-RestMethod called with Uri: $Uri" -Verbose
            
            $ClientId = $Body["client_id"]
            $scope = $Body["scope"] ?? "https://graph.microsoft.com/.default"

            if ($Body["client_assertion"]) {
                $CA = $Body["client_assertion"] | ConvertFrom-EntraIDAccessToken -AsHashTable
                if ($CA.payload.aud -ne "fb60f99c-7a34-4190-8149-302f77469936") {
                    throw "Invalid audience $($CA.payload.aud) in client_assertion"
                }
            }

            $aud = ($scope.Replace("/.default", "")) -replace "api://AzureADTokenExchange", "fb60f99c-7a34-4190-8149-302f77469936"

            return @{
                access_token = New-DummyJWT -Aud $aud -Iss "https://sts.windows.net/$($Script:TenantId)/" -Sub $ClientId -Verbose
                expires_in   = "3599"
                expires_on   = (Get-Date -Date (Get-Date).AddHours(1) -UFormat %s)
            }
        }
    }

    It "Calls the Add-EntraIDFederatedCredentialTokenProfile function without throwing an error" {
        { Add-EntraIDClientSecretAccessTokenProfile -Name "CredItself" -ClientId $Script:ClientIdForCredItself -TenantId $Script:TenantId -ClientSecret (ConvertTo-SecureString -String "dummy" -AsPlainText -Force) -Scope "api://AzureADTokenExchange/.default" } | Should -Not -Throw
        { Add-EntraIDFederatedCredentialTokenProfile -Name "Fedprod" -Scope "https://graph.microsoft.com/.default" -ClientId $Script:ClientIdWithFedCred -TenantId $Script:TenantId -FederatedAccessTokenProfile "CredItself" } | Should -Not -Throw

        $AccessToken = Get-EntraIDAccessToken -Profile "Fedprod" | ConvertFrom-EntraIDAccessToken -AsHashTable

        $AccessToken.Payload.iss | Should -BeLike "*$($Script:TenantId)*"
        $AccessToken.Payload.aud | Should -Be "https://graph.microsoft.com"
    }
}