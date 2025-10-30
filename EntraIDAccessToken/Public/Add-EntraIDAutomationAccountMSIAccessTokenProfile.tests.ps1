BeforeAll {
    $Script:Module = Import-Module "$PSScriptRoot/../" -Force -PassThru
    $Script:SystemAssignedManagedIdentityClientId = "11223344-5566-7788-99aa-bbccddeeff00"
    $Script:UserAssignedManagedIdentityClientId = "abcdefab-cdef-cdef-cdef-abcdefabcdef"
    $Script:TrustingApplicationClientId = "00112233-4455-6677-8899-aabbccddeeff"
    $Script:TenantId = "12345678-1234-1234-1234-123456789012"
}

Describe "Add-EntraIDAutomationAccountMSIAccessTokenProfile.1" -Tag Mocked {
    It "Fails when running without the IDENTITY_HEADER" {
        $ENV:IDENTITY_HEADER = $null
        $Name = (New-Guid).ToString()
        
        { Add-EntraIDAutomationAccountMSIAccessTokenProfile -Name $Name } | Should -Throw
    }

    It "Fails when running without the IDENTITY_ENDPOINT" {
        $ENV:IDENTITY_HEADER = "..."
        $ENV:IDENTITY_ENDPOINT = $null
        $Name = (New-Guid).ToString()
        
        { Add-EntraIDAutomationAccountMSIAccessTokenProfile -Name $Name } | Should -Throw
    }
}

Describe "Add-EntraIDAutomationAccountMSIAccessTokenProfile.2" -Tag Mocked {
    BeforeAll {
        Mock -ModuleName $Script:Module.Name -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like "http://dummy.fortytwo.io/" } -MockWith {
            Write-Verbose "Mocked Invoke-RestMethod called with Uri: $Uri" -Verbose

            if($headers.'X-IDENTITY-HEADER' -ne "some_value") {
                throw "Invalid IDENTITY_HEADER"
            }

            $clientid = $Body["client_id"] ?? $Script:SystemAssignedManagedIdentityClientId
            $resource = $Body["resource"] ?? "https://graph.microsoft.com"

            return @{
                access_token = New-DummyJWT -Aud $resource -Iss "https://sts.windows.net/$($Script:TenantId)/" -Sub $clientid -Verbose
                expires_in   = "3599"
                expires_on   = (Get-Date -Date (Get-Date).AddHours(1) -UFormat %s)
            }
        }

        Mock -ModuleName $Script:Module.Name -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like "https://login.microsoftonline.com/$($Script:TenantId)/oauth2/token" } -MockWith {
            Write-Verbose "Mocked Invoke-RestMethod called with Uri: $Uri" -Verbose
            
            $ClientId = $Body["client_id"]
            $scope = $Body["scope"] ?? "https://graph.microsoft.com/.default"

            return @{
                access_token = New-DummyJWT -Aud ($scope.Replace("/.default","")) -Iss "https://sts.windows.net/$($Script:TenantId)/" -Sub $clientid -Verbose
                expires_in   = "3599"
                expires_on   = (Get-Date -Date (Get-Date).AddHours(1) -UFormat %s)
            }
        }
    }

    It "Returns an access token for system assigned managed identity when environment variables are set" {
        $ENV:IDENTITY_HEADER = "some_value"
        $ENV:IDENTITY_ENDPOINT = "http://dummy.fortytwo.io/"
        $Name = (New-Guid).ToString()

        { Add-EntraIDAutomationAccountMSIAccessTokenProfile -Name $Name } | Should -Not -Throw
        $AccessToken = Get-EntraIDAccessToken -Profile $Name | ConvertFrom-EntraIDAccessToken

        $AccessToken.Payload.iss | Should -BeLike "*$($Script:TenantId)*"
        $AccessToken.Payload.aud | Should -Be "https://graph.microsoft.com"
        $AccessToken.Payload.sub | Should -Be $Script:SystemAssignedManagedIdentityClientId
    }

    It "Returns an access token for user assigned managed identity when environment variables are set" {
        $ENV:IDENTITY_HEADER = "some_value"
        $ENV:IDENTITY_ENDPOINT = "http://dummy.fortytwo.io/"
        $Name = (New-Guid).ToString()

        { Add-EntraIDAutomationAccountMSIAccessTokenProfile -Name $Name -ClientId $Script:UserAssignedManagedIdentityClientId } | Should -Not -Throw
        $AccessToken = Get-EntraIDAccessToken -Profile $Name | ConvertFrom-EntraIDAccessToken

        $AccessToken.Payload.iss | Should -BeLike "*$($Script:TenantId)*"
        $AccessToken.Payload.aud | Should -Be "https://graph.microsoft.com"
        $AccessToken.Payload.sub | Should -Be $Script:UserAssignedManagedIdentityClientId
    }

    It "Returns an access token for the trusting application when environment variables are set" {
        $ENV:IDENTITY_HEADER = "some_value"
        $ENV:IDENTITY_ENDPOINT = "http://dummy.fortytwo.io/"
        $Name = (New-Guid).ToString()

        { Add-EntraIDAutomationAccountMSIAccessTokenProfile -Name $Name -TenantId $Script:TenantId -TrustingApplicationClientId $Script:TrustingApplicationClientId -ClientId $Script:UserAssignedManagedIdentityClientId } | Should -Not -Throw
        $AccessToken = Get-EntraIDAccessToken -Profile $Name | ConvertFrom-EntraIDAccessToken

        $AccessToken.Payload.iss | Should -BeLike "*$($Script:TenantId)*"
        $AccessToken.Payload.aud | Should -Be "https://graph.microsoft.com"
        $AccessToken.Payload.sub | Should -Be $Script:TrustingApplicationClientId
    }
}