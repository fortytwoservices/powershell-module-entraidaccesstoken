BeforeAll {
    Import-Module ../EntraIDAccessToken -Force
}

Describe "Add-EntraIDClientSecretAccessTokenProfile.1" {
    BeforeAll {
        $Name = (New-Guid).ToString()
        Add-EntraIDClientSecretAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPesterClientId -ClientSecret (ConvertTo-SecureString $ENV:EIDATPesterClientSecret -AsPlainText -Force) -TenantId $ENV:EIDATPesterTenantId
    }

    It "Creates a profile with client secret authentication" {
        $P = Get-EntraIDAccessTokenProfile -Profile $Name 
        $P.Name | Should -Be $Name
        $P.AuthenticationMethod | Should -Be "clientsecret"
        $P.ClientId | Should -Be $ENV:EIDATPesterClientId
        $P.TenantId | Should -Be $ENV:EIDATPesterTenantId
        $P.Resource | Should -Be "https://graph.microsoft.com"
    }

    It "Returns an access token" {
        $AT = Get-EntraIDAccessToken -Profile $Name
        $AT | Should -BeLike "ey*.ey*.*"
    }
}

Describe "Add-EntraIDClientSecretAccessTokenProfile.2" {
    BeforeAll {
        $Name = (New-Guid).ToString()
        Add-EntraIDClientSecretAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPesterClientId -ClientSecret (ConvertTo-SecureString $ENV:EIDATPesterClientSecret -AsPlainText -Force) -TenantId $ENV:EIDATPesterTenantId -Resource "https://vault.azure.net"
    }

    It "Creates a profile with client secret authentication" {
        $P = Get-EntraIDAccessTokenProfile -Profile $Name 
        $P.Name | Should -Be $Name
        $P.AuthenticationMethod | Should -Be "clientsecret"
        $P.ClientId | Should -Be $ENV:EIDATPesterClientId
        $P.TenantId | Should -Be $ENV:EIDATPesterTenantId
        $P.Resource | Should -Be "https://vault.azure.net"
    }

    It "Returns an access token for the correct audience" {
        $AT = Get-EntraIDAccessToken -Profile $Name
        $AT | Should -BeLike "ey*.ey*.*"
        ($AT | ConvertFrom-EntraIDAccessToken).Payload.aud | Should -Be "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"
    }
}

Describe "Add-EntraIDClientCertificateAccessTokenProfile.1" {
    BeforeAll {
        $Name = (New-Guid).ToString()
        Add-EntraIDClientCertificateAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPesterClientId -TenantId $ENV:EIDATPesterTenantId -Thumbprint $ENV:EIDATPesterCertificateThumbprint
    }

    It "Creates a profile with client secret authentication" {
        $P = Get-EntraIDAccessTokenProfile -Profile $Name 
        $P.Name | Should -Be $Name
        $P.AuthenticationMethod | Should -Be "clientcertificate"
        $P.ClientId | Should -Be $ENV:EIDATPesterClientId
        $P.TenantId | Should -Be $ENV:EIDATPesterTenantId
        $P.Resource | Should -Be "https://graph.microsoft.com"
    }

    It "Returns an access token for the correct audience" {
        $AT = Get-EntraIDAccessToken -Profile $Name
        $AT | Should -BeLike "ey*.ey*.*"
        ($AT | ConvertFrom-EntraIDAccessToken).Payload.aud | Should -Be "https://graph.microsoft.com"
    }

    It "Fails when providing scope and resource at the same time" {
        $Name = (New-Guid).ToString()
        { 
            Add-EntraIDClientCertificateAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPesterClientId -TenantId $ENV:EIDATPesterTenantId -Thumbprint $ENV:EIDATPesterCertificateThumbprint -Resource "https://graph.microsoft.com" -Scope "https://management.azure.com/.default"
        } | Should -Throw "Cannot specify both Resource and Scope"
    }

    It "Should fail when providing a certificate thumbprint that does not exist" {
        $Name = (New-Guid).ToString()
        { 
            Add-EntraIDClientCertificateAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPesterClientId -TenantId $ENV:EIDATPesterTenantId -Thumbprint "InvalidThumbprint"
        } | Should -Throw "Certificate with thumbprint InvalidThumbprint not found"
    }
}

Describe "Add-EntraIDClientCertificateAccessTokenProfile.2" {
    BeforeAll {
        $Name = (New-Guid).ToString()
        Add-EntraIDClientCertificateAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPesterClientId -TenantId $ENV:EIDATPesterTenantId -Path $ENV:EIDATPesterCertificatePFXPath -Password (ConvertTo-SecureString $ENV:EIDATPesterCertificatePFXPassword -AsPlainText -Force) -Scope "https://management.azure.com/.default"
    }

    It "Creates a profile with client secret authentication" {
        $P = Get-EntraIDAccessTokenProfile -Profile $Name 
        $P.Name | Should -Be $Name
        $P.AuthenticationMethod | Should -Be "clientcertificate"
        $P.ClientId | Should -Be $ENV:EIDATPesterClientId
        $P.TenantId | Should -Be $ENV:EIDATPesterTenantId
        $P.Scope | Should -Be "https://management.azure.com/.default"
    }

    It "Returns an access token for the correct audience" {
        $AT = Get-EntraIDAccessToken -Profile $Name
        $AT | Should -BeLike "ey*.ey*.*"
        ($AT | ConvertFrom-EntraIDAccessToken).Payload.aud | Should -Be "https://management.azure.com"
    }

    It "Fails when providing scope and resource at the same time" {
        $Name = (New-Guid).ToString()
        { 
            Add-EntraIDClientCertificateAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPesterClientId -TenantId $ENV:EIDATPesterTenantId -Path $ENV:EIDATPesterCertificatePFXPath -Password (ConvertTo-SecureString $ENV:EIDATPesterCertificatePFXPassword -AsPlainText -Force) -Resource "https://graph.microsoft.com" -Scope "https://management.azure.com/.default"
        } | Should -Throw "Cannot specify both Resource and Scope"
    }

    It "Should fail when providing a pfx that does not exist" {
        $Name = (New-Guid).ToString()
        { 
            Add-EntraIDClientCertificateAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPesterClientId -TenantId $ENV:EIDATPesterTenantId -Path "InvalidPath" -Password (ConvertTo-SecureString $ENV:EIDATPesterCertificatePFXPassword -AsPlainText -Force)
        } | Should -Throw "Path InvalidPath does not exist"
    }

    It "Should fail when provinding the wrong password" {
        $Name = (New-Guid).ToString()
        { 
            Add-EntraIDClientCertificateAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPesterClientId -TenantId $ENV:EIDATPesterTenantId -Path $ENV:EIDATPesterCertificatePFXPath -Password (ConvertTo-SecureString "WrongPassword" -AsPlainText -Force)
        } | Should -Throw "*The specified network password is not correct*"
    }
}

Describe "Add-EntraIDROPCAccessTokenProfile.1" {
    BeforeAll {
        $Name = (New-Guid).ToString()
        Add-EntraIDROPCAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPesterClientId -TenantId $ENV:EIDATPesterTenantId -UserCredential (New-Object System.Management.Automation.PSCredential($ENV:EIDATPesterUsername, (ConvertTo-SecureString $ENV:EIDATPesterPassword -AsPlainText -Force))) -ClientSecret (ConvertTo-SecureString $ENV:EIDATPesterClientSecret -AsPlainText -Force)
    }

    It "Creates a profile with ROPC authentication" {
        $P = Get-EntraIDAccessTokenProfile -Profile $Name 
        $P.Name | Should -Be $Name
        $P.AuthenticationMethod | Should -Be "ropc"
        $P.ClientId | Should -Be $ENV:EIDATPesterClientId
        $P.TenantId | Should -Be $ENV:EIDATPesterTenantId
        $P.Scope | Should -Be "https://graph.microsoft.com/.default offline_access"
        $P.RefreshToken | Should -Be $true
    }

    It "Returns an access token for the correct audience" {
        $AT = Get-EntraIDAccessToken -Profile $Name
        $AT | Should -BeLike "ey*.ey*.*"
        ($AT | ConvertFrom-EntraIDAccessToken).Payload.aud | Should -Be "https://graph.microsoft.com"
        ($AT | ConvertFrom-EntraIDAccessToken).Payload.upn | Should -Be $ENV:EIDATPesterUsername
        ($AT | ConvertFrom-EntraIDAccessToken).Payload.idtyp | Should -Be "user"
    }
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