# EntraIDAccessToken PowerShell Module

This module was created in order to eliminate the need to build authentication into each and every other module that talks to Entra ID. Instead of having 10 different modules, each with different options for client secrets, client certificates, managed service identities etc. this is built into this module and consumed by other modules. This module also takes care of caching, expiration, etc.

The overall approach to using the module is:

1. Load the module (duh...)
2. Add profiles using one or more of the following profiles:
  - Add-EntraIDClientSecretAccessTokenProfile
  - Add-EntraIDAutomationAccountMSIAccessTokenProfile
  - Add-EntraIDAzureDevOpsFederatedCredentialAccessTokenProfile
  - Add-EntraIDExternalAccessTokenProfile
3. Utilize ```Get-EntraIDAccessToken -Profile "Name"``` in scripts and modules to get the token

## Example 1 - Adding a profile using client secret authentication

```PowerShell
Add-EntraIDClientSecretAccessTokenProfile
```
