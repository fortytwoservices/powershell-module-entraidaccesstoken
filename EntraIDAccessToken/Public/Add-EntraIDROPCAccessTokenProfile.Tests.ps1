BeforeAll {
    Import-Module ./EntraIDAccessToken -Force

    $ENV:EIDATPESTERTENANTID = "bb73082a-b74c-4d39-aec0-41c77d6f4850"
    $ENV:EIDATPESTERCLIENTID = "bad81856-fc31-47a6-8755-b42ef8025a49"
    #$ENV:EIDATPESTERCLIENTSECRET ??= Read-Host -Prompt "Enter client secret for $($ENV:EIDATPESTERCLIENTID)"
    $ENV:EIDATPESTERUSERNAME = "pester.azurear@labs.fortytwo.io"
    #$ENV:EIDATPESTERPASSWORD ??= Read-Host -Prompt "Enter password for $($ENV:EIDATPESTERUSERNAME)"
}

Describe "Add-EntraIDROPCAccessTokenProfile.1" {
    BeforeAll {
        $Name = (New-Guid).ToString()
        Add-EntraIDROPCAccessTokenProfile -Name $Name -ClientId $ENV:EIDATPESTERCLIENTID -TenantId $ENV:EIDATPESTERTENANTID -UserCredential (New-Object System.Management.Automation.PSCredential($ENV:EIDATPESTERUSERNAME, (ConvertTo-SecureString $ENV:EIDATPESTERPASSWORD -AsPlainText -Force))) -ClientSecret (ConvertTo-SecureString $ENV:EIDATPESTERCLIENTSECRET -AsPlainText -Force)
    }

    It "Creates a profile with ROPC authentication" {
        $P = Get-EntraIDAccessTokenProfile -Profile $Name 
        $P.Name | Should -Be $Name
        $P.AuthenticationMethod | Should -Be "ropc"
        $P.ClientId | Should -Be $ENV:EIDATPESTERCLIENTID
        $P.TenantId | Should -Be $ENV:EIDATPESTERTENANTID
        $P.Scope | Should -Be "https://graph.microsoft.com/.default offline_access"
        $P.RefreshToken | Should -Be $true
    }

    It "Returns an access token for the correct audience" {
        $AT = Get-EntraIDAccessToken -Profile $Name
        $AT | Should -BeLike "ey*.ey*.*"
        ($AT | ConvertFrom-EntraIDAccessToken).Payload.aud | Should -Be "https://graph.microsoft.com"
        ($AT | ConvertFrom-EntraIDAccessToken).Payload.upn | Should -Be $ENV:EIDATPESTERUSERNAME
        ($AT | ConvertFrom-EntraIDAccessToken).Payload.idtyp | Should -Be "user"
    }
}