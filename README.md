# EntraIDAccessToken PowerShell Module

This module was created in order to eliminate the need to build authentication into each and every other module that talks to Entra ID. Instead of having 10 different modules, each with different options for client secrets, client certificates, managed service identities etc. this is built into this module and consumed by other modules. This module also takes care of caching, expiration, etc.

The overall approach to using the module is:

1. Load the module (duh...)
2. Add profiles using one or more of the following profiles (examples 1.*):
  - Add-EntraIDClientSecretAccessTokenProfile
  - Add-EntraIDAutomationAccountMSIAccessTokenProfile
  - Add-EntraIDAzureDevOpsFederatedCredentialAccessTokenProfile
  - Add-EntraIDExternalAccessTokenProfile
3. Utilize ```Get-EntraIDAccessToken -Profile "Name"``` in scripts and modules to get the token (examples 2.*)

## Example 1.1 - Adding a default profile using client secret authentication and the Microsoft Graph resource

```PowerShell
$ClientSecret = Read-Host -AsSecureString
Add-EntraIDClientSecretAccessTokenProfile -ClientSecret $ClientSecret -TenantId "237098ae-0798-4cf9-a3a5-208374d2dcfd" -ClientId "179ba868-8e81-4bcb-b8e4-a3268fe8b13d"
```

## Example 1.2 - Adding a named profile using client secret authentication and Key Vault as resource

```PowerShell
$ClientSecret = Read-Host -AsSecureString
Add-EntraIDClientSecretAccessTokenProfile -Profile "Pegasus" -ClientSecret $ClientSecret -TenantId "237098ae-0798-4cf9-a3a5-208374d2dcfd" -ClientId "179ba868-8e81-4bcb-b8e4-a3268fe8b13d" -Resource "https://vault.azure.net/"
```

# Example 1.3 - Adding a profile using an Automation Account System Assigned Identity and the Microsoft Graph resource

```PowerShell
Add-EntraIDAutomationAccountMSIAccessTokenProfile
```

# Example 1.4 - Adding a profile using an Automation Account User Assigned Identity and Key Vault as resource

```PowerShell
Add-EntraIDAutomationAccountMSIAccessTokenProfile -ClientId "<uai clientid>" -Resource "https://vault.azure.net/"
```

# Example 1.5 - Adding a profileusing a hard coded access token (Useful for development)

```PowerShell
Add-EntraIDExternalAccessTokenProfile -AccessToken "ey..."
```

# Example 2.1 - Getting an access token for the default profile

```PowerShell
Get-EntraIDAccessToken
```

# Example 2.2 - Getting a refreshed access token for a certain profile

```PowerShell
Get-EntraIDAccessToken -ForceRefresh -Profile "Pegasus"
```