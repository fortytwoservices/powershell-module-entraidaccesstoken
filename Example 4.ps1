Import-Module ./EntraIDAccessToken -Force -Verbose

$ClientSecret ??= read-host -AsSecureString -Prompt "Client secret"
$UserCredential ??= Get-Credential -UserName "pester.azurear@labs.fortytwo.io"

Add-EntraIDROPCAccessTokenProfile `
    -Verbose `
    -TenantId "labs.fortytwo.io" `
    -ClientId "81d7e00b-5e6a-4c09-bb37-cddd821934ec" `
    -ClientSecret $ClientSecret `
    -UserCredential $UserCredential `
    -Scope "api://fe6b4fe4-d0d9-42ef-9085-28c201e87d39/.default"
    