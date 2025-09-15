BeforeAll {
    Import-Module ./EntraIDAccessToken -Force

    $ENV:EIDATPESTERTENANTID = "bb73082a-b74c-4d39-aec0-41c77d6f4850"
    $ENV:EIDATPESTERCLIENTID = "bad81856-fc31-47a6-8755-b42ef8025a49"
    #$ENV:EIDATPESTERCLIENTSECRET ??= Read-Host -Prompt "Enter client secret for $($ENV:EIDATPESTERCLIENTID)"
}

Describe "Add-EntraIDClientSecretAccessTokenProfile.1" {
    BeforeAll {
        $Name = (New-Guid).ToString()
        Add-EntraIDClientSecretAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPESTERCLIENTID -ClientSecret (ConvertTo-SecureString $ENV:EIDATPesterClientSecret -AsPlainText -Force) -TenantId $ENV:EIDATPESTERTENANTID
    }

    It "Creates a profile with client secret authentication" {
        $P = Get-EntraIDAccessTokenProfile -Profile $Name 
        $P.Name | Should -Be $Name
        $P.AuthenticationMethod | Should -Be "clientsecret"
        $P.ClientId | Should -Be $ENV:EIDATPESTERCLIENTID
        $P.TenantId | Should -Be $ENV:EIDATPESTERTENANTID
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
        Add-EntraIDClientSecretAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPESTERCLIENTID -ClientSecret (ConvertTo-SecureString $ENV:EIDATPesterClientSecret -AsPlainText -Force) -TenantId $ENV:EIDATPESTERTENANTID -Resource "https://vault.azure.net"
    }

    It "Creates a profile with client secret authentication" {
        $P = Get-EntraIDAccessTokenProfile -Profile $Name 
        $P.Name | Should -Be $Name
        $P.AuthenticationMethod | Should -Be "clientsecret"
        $P.ClientId | Should -Be $ENV:EIDATPESTERCLIENTID
        $P.TenantId | Should -Be $ENV:EIDATPESTERTENANTID
        $P.Resource | Should -Be "https://vault.azure.net"
    }

    It "Returns an access token for the correct audience" {
        $AT = Get-EntraIDAccessToken -Profile $Name
        $AT | Should -BeLike "ey*.ey*.*"
        ($AT | ConvertFrom-EntraIDAccessToken).Payload.aud | Should -Be "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"
    }
}