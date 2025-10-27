BeforeAll {
    $Script:Module = Import-Module ./EntraIDAccessToken -Force -PassThru
    $Script:TenantId = "12345678-1234-1234-1234-123456789012"
    $Script:UserAssignedManagedIdentityClientId = "abcdefab-cdef-cdef-cdef-abcdefabcdef"
    $Script:TrustingApplicationClientId = "87654321-4321-4321-4321-210987654321"
    $Script:SystemAssignedManagedIdentityClientId = "11223344-5566-7788-99aa-bbccddeeff00"
}

Describe "Add-EntraIDAzureVMMSIAccessTokenProfile.1" {
    BeforeAll {}

    It "Throws error when trying to use scope without a trusting application" {
        { Add-EntraIDAzureVMMSIAccessTokenProfile -Scope "https://graph.microsoft.com/.default" -TenantId $Script:TenantId } | Should -Throw
    }
}

Describe "Add-EntraIDAzureVMMSIAccessTokenProfile.2" {
    BeforeAll {
    
        Mock -ModuleName $Script:Module.Name -CommandName Invoke-WebRequest -ParameterFilter { $Uri -like "http://169.254.169.254/metadata/identity/oauth2/token*" } -MockWith {
            Write-Verbose "Mocked Invoke-WebRequest called with Uri: $Uri" -Verbose

            $qs = [System.Web.HttpUtility]::ParseQueryString([Uri]::new($Uri).Query)
            $aud = $qs["resource"] ?? "00000003-0000-0000-c000-000000000000"
            $clientid = $qs["client_id"] ?? $Script:SystemAssignedManagedIdentityClientId

            return @{
                StatusCode = 200
                Content    = @{
                    access_token = New-DummyJWT -Aud $Aud -Iss "https://sts.windows.net/$($Script:TenantId)/" -Sub $clientid -Verbose
                    expires_in   = "3599"
                    expires_on   = (Get-Date -Date (Get-Date).AddHours(1) -UFormat %s)
                } | ConvertTo-Json -Depth 5
            }
        }

        Mock -ModuleName $Script:Module.Name -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like "https://login.microsoftonline.com/$($Script:TenantId)/oauth2/v2.0/token" } -MockWith {
            Write-Verbose "Mocked Invoke-RestMethod called with Uri: $Uri" -Verbose
            
            $ClientId = $Body["client_id"]
            $scope = $Body["scope"] ?? "https://graph.microsoft.com/.default"

            return @{
                access_token = New-DummyJWT -Aud ($scope.Replace(".default","")) -Iss "https://sts.windows.net/$($Script:TenantId)/" -Sub $clientid -Verbose
                expires_in   = "3599"
                expires_on   = (Get-Date -Date (Get-Date).AddHours(1) -UFormat %s)
            }
        }

        Mock -ModuleName $Script:Module.Name -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like "https://login.microsoftonline.com/$($Script:TenantId)/oauth2/token" } -MockWith {
            Write-Verbose "Mocked Invoke-RestMethod called with Uri: $Uri" -Verbose
            
            $ClientId = $Body["client_id"]
            $resource = $Body["resource"] ?? "00000003-0000-0000-c000-000000000000"

            return @{
                access_token = New-DummyJWT -Aud ($resource) -Iss "https://sts.windows.net/$($Script:TenantId)/" -Sub $clientid -Verbose
                expires_in   = "3599"
                expires_on   = (Get-Date -Date (Get-Date).AddHours(1) -UFormat %s)
            }
        }
    }

    It "Should return a mock token with the correct payload, when using system assigned identity and trusting app" -Tag "Mocked" {
        Add-EntraIDAzureVMMSIAccessTokenProfile -TenantId $Script:TenantId -TrustingApplicationClientId $Script:TrustingApplicationClientId

        $Decoded = Get-EntraIDAccessToken | ConvertFrom-EntraIDAccessToken
        $Decoded.Payload.Sub | Should -Be $Script:TrustingApplicationClientId
        $Decoded.Payload.Aud | Should -Be "https://graph.microsoft.com"
    }

    It "Should return a mock token with the correct payload, when using user assigned identity and trusting app" -Tag "Mocked" {
        Add-EntraIDAzureVMMSIAccessTokenProfile -TenantId $Script:TenantId -TrustingApplicationClientId $Script:TrustingApplicationClientId -UserAssignedIdentityClientId $Script:UserAssignedManagedIdentityClientId

        $Decoded = Get-EntraIDAccessToken | ConvertFrom-EntraIDAccessToken
        $Decoded.Payload.Sub | Should -Be $Script:TrustingApplicationClientId
        $Decoded.Payload.Aud | Should -Be "https://graph.microsoft.com"
    }

    It "Should return a mock token with the correct payload, when using user assigned identity" -Tag "Mocked" {
        Add-EntraIDAzureVMMSIAccessTokenProfile -UserAssignedIdentityClientId $Script:UserAssignedManagedIdentityClientId

        $Decoded = Get-EntraIDAccessToken | ConvertFrom-EntraIDAccessToken
        $Decoded.Payload.Sub | Should -Be $Script:UserAssignedManagedIdentityClientId
        $Decoded.Payload.Aud | Should -Be "https://graph.microsoft.com"
    }

    It "Should return a mock token with the correct payload, when using system assigned identity" -Tag "Mocked" {
        Add-EntraIDAzureVMMSIAccessTokenProfile

        $Decoded = Get-EntraIDAccessToken | ConvertFrom-EntraIDAccessToken
        $Decoded.Payload.Sub | Should -Be $Script:SystemAssignedManagedIdentityClientId
        $Decoded.Payload.Aud | Should -Be "https://graph.microsoft.com"
    }
}