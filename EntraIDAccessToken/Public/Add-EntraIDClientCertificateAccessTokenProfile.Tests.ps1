BeforeAll {
    Import-Module ./EntraIDAccessToken -Force

    $ENV:EIDATPESTERTENANTID = "bb73082a-b74c-4d39-aec0-41c77d6f4850"
    $ENV:EIDATPESTERCLIENTID = "bad81856-fc31-47a6-8755-b42ef8025a49"
    #$ENV:EIDATPESTERCLIENTSECRET ??= Read-Host -Prompt "Enter client secret for $($ENV:EIDATPESTERCLIENTID)"
    $ENV:EIDATPESTERCERTIFICATETHUMBPRINT = "D08A6C49E577AEB7DE4468CD49143288D6F4B003"

    if ($ENV:EIDATPESTERCERTIFICATEPFX) {
        $ENV:EIDATPESTERCERTIFICATEPFXPATH = Join-Path (get-item .) ("pester.pfx")
        [IO.File]::WriteAllBytes($ENV:EIDATPESTERCERTIFICATEPFXPATH, [Convert]::FromBase64String($ENV:EIDATPESTERCERTIFICATEPFX))
    }
    $ENV:EIDATPESTERCERTIFICATEPFXPATH = "./pester.pfx"
    
    #$ENV:EIDATPESTERCERTIFICATEPFXPASSWORD ??= Read-Host -Prompt "Enter password for $($ENV:EIDATPESTERCERTIFICATEPFXPATH)"
    $ENV:EIDATPESTERUSERNAME = "pester.azurear@labs.fortytwo.io"
    #$ENV:EIDATPESTERPASSWORD ??= Read-Host -Prompt "Enter password for $($ENV:EIDATPESTERUSERNAME)"
}

Describe "Add-EntraIDClientCertificateAccessTokenProfile.1" -Tag "WindowsOnly" {
    BeforeAll {
        if (!("Cert:\CurrentUser\my", "Cert:\LocalMachine\my" | Get-ChildItem | Where-Object ThumbPrint -eq $ENV:EIDATPESTERCERTIFICATETHUMBPRINT)) {
            Write-Host "Importing certificate with thumbprint $ENV:EIDATPESTERCERTIFICATETHUMBPRINT to CurrentUser\My store for testing purposes"
            Import-PfxCertificate $ENV:EIDATPESTERCERTIFICATEPFXPATH -Password (ConvertTo-SecureString -String $ENV:EIDATPESTERCERTIFICATEPFXPASSWORD -AsPlainText -Force) -CertStoreLocation "Cert:\CurrentUser\My\"
        }

        $Name = (New-Guid).ToString()
        Add-EntraIDClientCertificateAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPESTERCLIENTID -TenantId $ENV:EIDATPESTERTENANTID -Thumbprint $ENV:EIDATPESTERCERTIFICATETHUMBPRINT
    }

    It "Creates a profile with client secret authentication" {
        $P = Get-EntraIDAccessTokenProfile -Profile $Name 
        $P.Name | Should -Be $Name
        $P.AuthenticationMethod | Should -Be "clientcertificate"
        $P.ClientId | Should -Be $ENV:EIDATPESTERCLIENTID
        $P.TenantId | Should -Be $ENV:EIDATPESTERTENANTID
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
            Add-EntraIDClientCertificateAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPESTERCLIENTID -TenantId $ENV:EIDATPESTERTENANTID -Thumbprint $ENV:EIDATPESTERCERTIFICATETHUMBPRINT -Resource "https://graph.microsoft.com" -Scope "https://management.azure.com/.default"
        } | Should -Throw "Cannot specify both Resource and Scope"
    }

    It "Should fail when providing a certificate thumbprint that does not exist" {
        $Name = (New-Guid).ToString()
        { 
            Add-EntraIDClientCertificateAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPESTERCLIENTID -TenantId $ENV:EIDATPESTERTENANTID -Thumbprint "InvalidThumbprint"
        } | Should -Throw "Certificate with thumbprint InvalidThumbprint not found"
    }
}

Describe "Add-EntraIDClientCertificateAccessTokenProfile.2" {
    BeforeAll {
        $Name = (New-Guid).ToString()
        Add-EntraIDClientCertificateAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPESTERCLIENTID -TenantId $ENV:EIDATPESTERTENANTID -Path $ENV:EIDATPESTERCERTIFICATEPFXPATH -Password (ConvertTo-SecureString $ENV:EIDATPESTERCERTIFICATEPFXPASSWORD -AsPlainText -Force) -Scope "https://management.azure.com/.default"
    }

    It "Creates a profile with client secret authentication" {
        $P = Get-EntraIDAccessTokenProfile -Profile $Name 
        $P.Name | Should -Be $Name
        $P.AuthenticationMethod | Should -Be "clientcertificate"
        $P.ClientId | Should -Be $ENV:EIDATPESTERCLIENTID
        $P.TenantId | Should -Be $ENV:EIDATPESTERTENANTID
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
            Add-EntraIDClientCertificateAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPESTERCLIENTID -TenantId $ENV:EIDATPESTERTENANTID -Path $ENV:EIDATPESTERCERTIFICATEPFXPATH -Password (ConvertTo-SecureString $ENV:EIDATPESTERCERTIFICATEPFXPASSWORD -AsPlainText -Force) -Resource "https://graph.microsoft.com" -Scope "https://management.azure.com/.default"
        } | Should -Throw "Cannot specify both Resource and Scope"
    }

    It "Should fail when providing a pfx that does not exist" {
        $Name = (New-Guid).ToString()
        { 
            Add-EntraIDClientCertificateAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPESTERCLIENTID -TenantId $ENV:EIDATPESTERTENANTID -Path "InvalidPath" -Password (ConvertTo-SecureString $ENV:EIDATPESTERCERTIFICATEPFXPASSWORD -AsPlainText -Force)
        } | Should -Throw "Path InvalidPath does not exist"
    }

    It "Should fail when provinding the wrong password" {
        $Name = (New-Guid).ToString()
        { 
            Add-EntraIDClientCertificateAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPESTERCLIENTID -TenantId $ENV:EIDATPESTERTENANTID -Path $ENV:EIDATPESTERCERTIFICATEPFXPATH -Password (ConvertTo-SecureString "WrongPassword" -AsPlainText -Force)
        } | Should -Throw
    }
}