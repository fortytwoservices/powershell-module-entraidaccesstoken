# Documentation for module EntraIDAccessToken

A module for simplifying the process of getting an access token from Entra ID

| Metadata | Information |
| --- | --- |
| Version | 2.21.0 |
| Author | Marius Solbakken Mellum |
| Company name | Fortytwo Technologies AS |
| PowerShell version | 7.1 |

## Add-EntraIDAutomationAccountMSIAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens using automation account managed identity.

### SYNTAX

#### default (Default)
```
Add-EntraIDAutomationAccountMSIAccessTokenProfile [-Name <String>] [-Resource <String>] [-ClientId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### trustingapplication
```
Add-EntraIDAutomationAccountMSIAccessTokenProfile [-Name <String>] [-Resource <String>] -TenantId <String>
 -TrustingApplicationClientId <String> [-ClientId <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
## Use the system assigned managed identity of the automation account
Add-EntraIDAutomationAccountMSIAccessTokenProfile
```

#### EXAMPLE 2
```
## Use a user assigned managed identity of the automation account
Add-EntraIDAutomationAccountMSIAccessTokenProfile -ClientId "12345678-1234-1234-1234-123456789012"
```

#### EXAMPLE 3
```
## Use a system assigned managed identity with a federated credential to an app registration
Add-EntraIDAutomationAccountMSIAccessTokenProfile -TenantId "12345678-1234-1234-1234-123456789012" -TrustingApplicationClientId "87654321-4321-4321-4321-210987654321"
```

#### EXAMPLE 4
```
## Use a user assigned managed identity with a federated credential to an app registration
Add-EntraIDAutomationAccountMSIAccessTokenProfile -ClientId "12345678-1234-1234-1234-123456789012" -TenantId "12345678-1234-1234-1234-123456789012" -TrustingApplicationClientId "87654321-4321-4321-4321-210987654321"
```

### PARAMETERS

#### -Name


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Resource


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Https://graph.microsoft.com
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TenantId


```yaml
Type: String
Parameter Sets: trustingapplication
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TrustingApplicationClientId


```yaml
Type: String
Parameter Sets: trustingapplication
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ClientId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Add-EntraIDAzureArcManagedMSITokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens using the system assigned identity on an Azure Arc enabled server.

### SYNTAX

#### default (Default)
```
Add-EntraIDAzureArcManagedMSITokenProfile [-Name <String>] [-Resource <String>] [-ClientId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### trustingapplication
```
Add-EntraIDAzureArcManagedMSITokenProfile [-Name <String>] [-Resource <String>] -TenantId <String>
 -TrustingApplicationClientId <String> [-ClientId <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DESCRIPTION
Adds a new profile for getting Entra ID access tokens using the system assigned identity on an Azure Arc enabled server.

### EXAMPLES

#### EXAMPLE 1
```
## Get a token for Microsoft Graph
Add-EntraIDAzureArcManagedMSITokenProfile
```

#### EXAMPLE 2
```
## Get a token for Microsoft Graph using an app registration with federated credentials from the system assigned identity
Add-EntraIDAzureArcManagedMSITokenProfile -TenantId "12345678-1234-1234-1234-123456789012" -TrustingApplicationClientId "87654321-4321-4321-4321-210987654321"
```

### PARAMETERS

#### -Name


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Resource


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Https://graph.microsoft.com
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TenantId


```yaml
Type: String
Parameter Sets: trustingapplication
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TrustingApplicationClientId


```yaml
Type: String
Parameter Sets: trustingapplication
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ClientId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Add-EntraIDAzureDevOpsFederatedCredentialAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

### SYNTAX

#### resource (Default)
```
Add-EntraIDAzureDevOpsFederatedCredentialAccessTokenProfile [-Name <String>] [-Resource <String>]
 [-TenantId <String>] [-ClientId <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### scope
```
Add-EntraIDAzureDevOpsFederatedCredentialAccessTokenProfile [-Name <String>] [-Scope <String>]
 [-TenantId <String>] [-ClientId <String>] [-V2Token] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Add-EntraIDAccessTokenProfile
```

### PARAMETERS

#### -Name


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Resource


```yaml
Type: String
Parameter Sets: resource
Aliases:

Required: False
Position: Named
Default value: Https://graph.microsoft.com
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Scope


```yaml
Type: String
Parameter Sets: scope
Aliases:

Required: False
Position: Named
Default value: Https://graph.microsoft.com/.default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TenantId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $ENV:AZURESUBSCRIPTION_TENANT_ID
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ClientId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $ENV:AZURESUBSCRIPTION_CLIENT_ID
Accept pipeline input: False
Accept wildcard characters: False
```

#### -V2Token
Specifies that we want a V2 token

```yaml
Type: SwitchParameter
Parameter Sets: scope
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Add-EntraIDAzurePowerShellSessionTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

### SYNTAX

```
Add-EntraIDAzurePowerShellSessionTokenProfile [[-Name] <String>] [[-Resource] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Add-EntraIDAccessTokenProfile
```

### PARAMETERS

#### -Name


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Resource


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Https://graph.microsoft.com
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Add-EntraIDAzureVMMSIAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens using the system assigned or user assigned identity on an Azure VM.

### SYNTAX

#### resource (Default)
```
Add-EntraIDAzureVMMSIAccessTokenProfile [-Name <String>] [-Resource <String>]
 [-UserAssignedIdentityClientId <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### resource+trustingapplication
```
Add-EntraIDAzureVMMSIAccessTokenProfile [-Name <String>] [-Resource <String>] -TenantId <String>
 -TrustingApplicationClientId <String> [-UserAssignedIdentityClientId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### scope+trustingapplication
```
Add-EntraIDAzureVMMSIAccessTokenProfile [-Name <String>] -Scope <String> -TenantId <String>
 -TrustingApplicationClientId <String> [-UserAssignedIdentityClientId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION
Adds a new profile for getting Entra ID access tokens using the system assigned or user assigned identity on an Azure VM.

### EXAMPLES

#### EXAMPLE 1
```
## Get a token for Microsoft Graph using the system assigned identity
Add-EntraIDAzureVMMSIAccessTokenProfile
```

#### EXAMPLE 2
```
## Get a token for Microsoft Graph using a user assigned assigned identity
Add-EntraIDAzureVMMSIAccessTokenProfile -UserAssignedIdentityClientId "87654321-4321-4321-4321-210987654321"
```

#### EXAMPLE 3
```
## Get a token for Microsoft Graph using an app registration with federated credentials from the system assigned identity
Add-EntraIDAzureVMAccessTokenProfile -TenantId "12345678-1234-1234-1234-123456789012" -TrustingApplicationClientId "87654321-4321-4321-4321-210987654321"
```

#### EXAMPLE 4
```
## Get a token for Microsoft Graph using an app registration with federated credentials from a user assigned identity
Add-EntraIDAzureVMAccessTokenProfile -TenantId "12345678-1234-1234-1234-123456789012" -TrustingApplicationClientId "87654321-4321-4321-4321-210987654321" -UserAssignedIdentityClientId "87654321-4321-4321-4321-210987654321"
```

#### EXAMPLE 5
```
## Get a token for Fortytwo Universe using an app registration with federated credentials from the system assigned identity
Add-EntraIDAzureVMAccessTokenProfile -TenantId "12345678-1234-1234-1234-123456789012" -TrustingApplicationClientId "87654321-4321-4321-4321-210987654321" -Scope "https://api.fortytwo.io/.default"
```

### PARAMETERS

#### -Name


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Resource


```yaml
Type: String
Parameter Sets: resource, resource+trustingapplication
Aliases:

Required: False
Position: Named
Default value: Https://graph.microsoft.com
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Scope


```yaml
Type: String
Parameter Sets: scope+trustingapplication
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TenantId


```yaml
Type: String
Parameter Sets: resource+trustingapplication, scope+trustingapplication
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TrustingApplicationClientId


```yaml
Type: String
Parameter Sets: resource+trustingapplication, scope+trustingapplication
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -UserAssignedIdentityClientId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Add-EntraIDClientCertificateAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

### SYNTAX

#### x509certificate2-resource (Default)
```
Add-EntraIDClientCertificateAccessTokenProfile [-Name <String>] [-Resource <String>]
 -Certificate <X509Certificate2> -ClientId <String> -TenantId <String> [-TokenVersion <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### thumbprint-resource
```
Add-EntraIDClientCertificateAccessTokenProfile [-Name <String>] [-Resource <String>] -Thumbprint <String>
 -ClientId <String> -TenantId <String> [-TokenVersion <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

#### pfx-resource
```
Add-EntraIDClientCertificateAccessTokenProfile [-Name <String>] [-Resource <String>] -Path <String>
 -Password <SecureString> -ClientId <String> -TenantId <String> [-TokenVersion <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### pfx-scope
```
Add-EntraIDClientCertificateAccessTokenProfile [-Name <String>] -Scope <String> -Path <String>
 -Password <SecureString> -ClientId <String> -TenantId <String> [-TokenVersion <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### thumbprint-scope
```
Add-EntraIDClientCertificateAccessTokenProfile [-Name <String>] -Scope <String> -Thumbprint <String>
 -ClientId <String> -TenantId <String> [-TokenVersion <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

#### x509certificate2-scope
```
Add-EntraIDClientCertificateAccessTokenProfile [-Name <String>] -Scope <String> -Certificate <X509Certificate2>
 -ClientId <String> -TenantId <String> [-TokenVersion <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Add-EntraIDAccessTokenProfile
```

### PARAMETERS

#### -Name


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Resource


```yaml
Type: String
Parameter Sets: x509certificate2-resource, thumbprint-resource, pfx-resource
Aliases:

Required: False
Position: Named
Default value: Https://graph.microsoft.com
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Scope


```yaml
Type: String
Parameter Sets: pfx-scope, thumbprint-scope, x509certificate2-scope
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Certificate


```yaml
Type: X509Certificate2
Parameter Sets: x509certificate2-resource, x509certificate2-scope
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Thumbprint


```yaml
Type: String
Parameter Sets: thumbprint-resource, thumbprint-scope
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Path


```yaml
Type: String
Parameter Sets: pfx-resource, pfx-scope
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Password


```yaml
Type: SecureString
Parameter Sets: pfx-resource, pfx-scope
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ClientId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TenantId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TokenVersion


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: V1
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Add-EntraIDClientSecretAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

### SYNTAX

#### resource (Default)
```
Add-EntraIDClientSecretAccessTokenProfile [-Name <String>] [-Resource <String>] -TenantId <String>
 -ClientSecret <SecureString> -ClientId <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### scope
```
Add-EntraIDClientSecretAccessTokenProfile [-Name <String>] [-Scope <String>] -TenantId <String>
 -ClientSecret <SecureString> -ClientId <String> [-V2Token] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Add-EntraIDAccessTokenProfile
```

### PARAMETERS

#### -Name


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Resource


```yaml
Type: String
Parameter Sets: resource
Aliases:

Required: False
Position: Named
Default value: Https://graph.microsoft.com
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Scope


```yaml
Type: String
Parameter Sets: scope
Aliases:

Required: False
Position: Named
Default value: Https://graph.microsoft.com/.default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TenantId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ClientSecret


```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ClientId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -V2Token
Specifies that we want a V2 token

```yaml
Type: SwitchParameter
Parameter Sets: scope
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Add-EntraIDExternalAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

### SYNTAX

#### string (Default)
```
Add-EntraIDExternalAccessTokenProfile [-Name <String>] -AccessToken <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### securestring
```
Add-EntraIDExternalAccessTokenProfile [-Name <String>] -SecureStringAccessToken <SecureString>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### clipboard
```
Add-EntraIDExternalAccessTokenProfile [-Name <String>] [-Clipboard] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Add-EntraIDExternalAccessTokenProfile
```

### PARAMETERS

#### -Name


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -AccessToken


```yaml
Type: String
Parameter Sets: string
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -SecureStringAccessToken


```yaml
Type: SecureString
Parameter Sets: securestring
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Clipboard


```yaml
Type: SwitchParameter
Parameter Sets: clipboard
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Add-EntraIDFunctionAppMSIAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

### SYNTAX

#### default (Default)
```
Add-EntraIDFunctionAppMSIAccessTokenProfile [-Name <String>] [-Resource <String>] [-ClientId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### trustingapplication
```
Add-EntraIDFunctionAppMSIAccessTokenProfile [-Name <String>] [-Resource <String>] -TenantId <String>
 -TrustingApplicationClientId <String> [-ClientId <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Add-EntraIDAccessTokenProfile
```

### PARAMETERS

#### -Name


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Resource


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Https://graph.microsoft.com
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TenantId


```yaml
Type: String
Parameter Sets: trustingapplication
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TrustingApplicationClientId


```yaml
Type: String
Parameter Sets: trustingapplication
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ClientId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Add-EntraIDGitHubFederatedCredentialAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

### SYNTAX

#### scope (Default)
```
Add-EntraIDGitHubFederatedCredentialAccessTokenProfile [-Name <String>] [-Scope <String>] -TenantId <String>
 -ClientId <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### resource
```
Add-EntraIDGitHubFederatedCredentialAccessTokenProfile [-Name <String>] [-Resource <String>] -TenantId <String>
 -ClientId <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### v2
```
Add-EntraIDGitHubFederatedCredentialAccessTokenProfile [-Name <String>] -TenantId <String> -ClientId <String>
 [-V2Token] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Add-EntraIDGitHubFederatedCredentialAccessTokenProfile
```

### PARAMETERS

#### -Name


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Resource


```yaml
Type: String
Parameter Sets: resource
Aliases:

Required: False
Position: Named
Default value: Https://graph.microsoft.com
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Scope


```yaml
Type: String
Parameter Sets: scope
Aliases:

Required: False
Position: Named
Default value: Https://graph.microsoft.com/.default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TenantId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ClientId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -V2Token
Specifies that we want a V2 token

```yaml
Type: SwitchParameter
Parameter Sets: v2
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Add-EntraIDInteractiveUserAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

### SYNTAX

```
Add-EntraIDInteractiveUserAccessTokenProfile [[-Name] <String>] [[-Scope] <String>] [[-TenantId] <String>]
 [[-ClientId] <String>] [[-LocalhostPort] <Int32>] [[-Https] <Boolean>] [[-LaunchBrowser] <Boolean>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Add-EntraIDInteractiveUserAccessTokenProfile
```

### PARAMETERS

#### -Name


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Scope


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Https://graph.microsoft.com/.default offline_access
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TenantId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Common
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ClientId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 14d82eec-204b-4c2f-b7e8-296a70dab67e
Accept pipeline input: False
Accept wildcard characters: False
```

#### -LocalhostPort


```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: -1
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Https


```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -LaunchBrowser


```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Add-EntraIDROPCAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens using the Resource Owner Password Credentials (ROPC) flow.

### SYNTAX

```
Add-EntraIDROPCAccessTokenProfile [[-Name] <String>] [[-Scope] <String>] [-TenantId] <String>
 [-ClientId] <String> [-ClientSecret] <SecureString> [-UserCredential] <PSCredential>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Add-EntraIDROPCAccessTokenProfile.ps1
```

### PARAMETERS

#### -Name


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Scope


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Https://graph.microsoft.com/.default offline_access
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TenantId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ClientId


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ClientSecret


```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -UserCredential


```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Confirm-EntraIDAccessToken

### SYNOPSIS
Verifies that a provided token matches certain criteria

### SYNTAX

```
Confirm-EntraIDAccessToken [[-Tid] <String>] [[-Aud] <String>] [[-Iss] <String>] [[-Idtyp] <String>]
 [[-Idp] <String>] [[-Sub] <String>] [[-Appid] <String>] [[-Azp] <String>] [[-Oid] <String>]
 [[-Scopes] <String[]>] [[-Wids] <String[]>] [[-Roles] <String[]>] [[-OtherClaims] <Hashtable>]
 [-AccessToken] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Confirm-EntraIDAccessToken
```

### PARAMETERS

#### -Tid


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Aud


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Iss


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Idtyp


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Idp


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Sub


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Appid


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Azp


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Oid


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Scopes


```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Wids


```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Roles


```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -OtherClaims


```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -AccessToken


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 14
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## ConvertFrom-EntraIDAccessToken

### SYNOPSIS
Converts an Entra ID Access Token (JWT) into its components: Header, Payload, and Signature.

### SYNTAX

```
ConvertFrom-EntraIDAccessToken [-AccessToken] <String> [-AsHashTable] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DESCRIPTION
Converts an Entra ID Access Token (JWT) into its components: Header, Payload,

### EXAMPLES

#### EXAMPLE 1
```
Get-EntraIDAccessToken | ConvertFrom-EntraIDAccessToken
```

### PARAMETERS

#### -AccessToken


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

#### -AsHashTable


```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Get-EntraIDAccessToken

### SYNOPSIS
Gets an access token from Entra ID for the configured profile

### SYNTAX

```
Get-EntraIDAccessToken [[-Profile] <String>] [-ForceRefresh] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DESCRIPTION
Gets an access token from Entra ID for the configured profile.
The access token is cached until it is close to expiration, and a new token will be requested automatically when needed.

### EXAMPLES

#### EXAMPLE 1
```
Get-EntraIDAccessToken
```

#### EXAMPLE 2
```
Get-EntraIDAccessToken -Profile "API" -ForceRefresh
```

### PARAMETERS

#### -Profile


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ForceRefresh
If specified, a new access token will be requested even if the cached token is still valid

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Get-EntraIDAccessTokenHasRoles

### SYNOPSIS
Get a boolean indicating whether the input access token has all or any of the specified roles.

### SYNTAX

#### All (Default)
```
Get-EntraIDAccessTokenHasRoles -Roles <String[]> -AccessToken <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

#### Any
```
Get-EntraIDAccessTokenHasRoles -Roles <String[]> [-Any] -AccessToken <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION
Get a boolean indicating whether the input access token has all or any of the specified roles.

### EXAMPLES

#### EXAMPLE 1
```
Get-EntraIDAccessToken |Get-EntraIDAccessTokenHasRoles -Roles "Group.Create"
```

#### EXAMPLE 2
```
Get-EntraIDAccessToken |Get-EntraIDAccessTokenHasRoles -Roles "Group.Create", "Group.ReadWrite.All" -Any
```

### PARAMETERS

#### -Roles


```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Any


```yaml
Type: SwitchParameter
Parameter Sets: Any
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -AccessToken


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Get-EntraIDAccessTokenHasScopes

### SYNOPSIS
Get a boolean indicating whether the input access token has all or any of the specified roles.

### SYNTAX

#### All (Default)
```
Get-EntraIDAccessTokenHasScopes -Scopes <String[]> -AccessToken <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

#### Any
```
Get-EntraIDAccessTokenHasScopes -Scopes <String[]> [-Any] -AccessToken <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION
Get a boolean indicating whether the input access token has all or any of the specified roles.

### EXAMPLES

#### EXAMPLE 1
```
Get-EntraIDAccessToken |Get-EntraIDAccessTokenHasScopes -Scopes "Group.Read.All"
```

#### EXAMPLE 2
```
Get-EntraIDAccessToken |Get-EntraIDAccessTokenHasScopes -Scopes "Group.Read.All", "Group.ReadWrite.All" -Any
```

### PARAMETERS

#### -Scopes


```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Any


```yaml
Type: SwitchParameter
Parameter Sets: Any
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -AccessToken


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Get-EntraIDAccessTokenHeader

### SYNOPSIS
Gets an Entra ID Access Token in a header useable by Invoke-RestMethod or Invoke-WebRequest.

### SYNTAX

```
Get-EntraIDAccessTokenHeader [[-Profile] <String>] [-ConsistencyLevelEventual]
 [[-AdditionalHeaders] <Hashtable>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION
Gets an Entra ID Access Token in a header useable by Invoke-RestMethod or Invoke-WebRequest.
Additional headers can be added using the AdditionalHeaders parameter.

### EXAMPLES

#### EXAMPLE 1
```
Invoke-RestMethod "https://graph.microsoft.com/v1.0/users" -Headers (Get-EntraIDAccessTokenHeader)
```

#### EXAMPLE 2
```
Get-EntraIDAccessTokenHeader -Profile "API" -ConsistencyLevelEventual
```

#### EXAMPLE 3
```
Get-EntraIDAccessTokenHeader -Profile "API" -AdditionalHeaders @{"X-Custom-Header"="Value"}
```

### PARAMETERS

#### -Profile


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ConsistencyLevelEventual


```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -AdditionalHeaders


```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Get-EntraIDAccessTokenPayload

### SYNOPSIS
Decodes an input access token and returns the payload as a hash table

### SYNTAX

```
Get-EntraIDAccessTokenPayload [-InputObject] <String> [-AsHashTable] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Get-EntraIDAccessToken | Get-EntraIDAccessTokenPayload
```

### PARAMETERS

#### -InputObject


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

#### -AsHashTable


```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Get-EntraIDAccessTokenProfile

### SYNOPSIS
Gets the Entra ID Access Token profile(s).

### SYNTAX

```
Get-EntraIDAccessTokenProfile [[-Profile] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION
Gets the Entra ID Access Token profile(s).
This can be useful in order to see which resources, tenant IDs, client IDs and authentication methods are used.

### EXAMPLES

#### EXAMPLE 1
```
Get-EntraIDAccessTokenProfile
```

#### EXAMPLE 2
```
Get-EntraIDAccessTokenProfile -Profile "API"
```

### PARAMETERS

#### -Profile


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Get-EntraIDAccessTokenSecureString

### SYNOPSIS
Gets an access token from Entra ID for the configured profile, as a secure string

### SYNTAX

```
Get-EntraIDAccessTokenSecureString [[-Profile] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DESCRIPTION
Gets an access token from Entra ID for the configured profile, as a secure string

### EXAMPLES

#### EXAMPLE 1
```
Get-EntraIDAccessTokenSecureString
```

#### EXAMPLE 2
```
Get-EntraIDAccessTokenSecureString -Profile "API"
```

### PARAMETERS

#### -Profile


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## Get-EntraIDAccessTokenType

### SYNOPSIS
Returns whether the access token is for a user or an app

### SYNTAX

```
Get-EntraIDAccessTokenType [-AccessToken] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION
Returns whether the access token is for a user or an app

### EXAMPLES

#### EXAMPLE 1
```
Get-EntraIDAccessToken |Get-EntraIDAccessTokenType
```

### PARAMETERS

#### -AccessToken


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
## New-DummyJWT

### SYNOPSIS
{{ Fill in the Synopsis }}

### SYNTAX

```
New-DummyJWT [[-Header] <Hashtable>] [[-Aud] <String>] [[-Iss] <String>] [[-Sub] <String>] [[-Jti] <String>]
 [[-Nbf] <Int32>] [[-Exp] <Int32>] [[-Iat] <Int32>] [[-OtherClaims] <Hashtable>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

### PARAMETERS

#### -Aud


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Exp


```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Header


```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Iat


```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Iss


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Jti


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Nbf


```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -OtherClaims


```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Sub


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

#### None
### OUTPUTS

#### System.Object
### NOTES

### RELATED LINKS
## Write-EntraIDAccessToken

### SYNOPSIS
Write an Entra ID Access Token to the console with color coding.

### SYNTAX

```
Write-EntraIDAccessToken [-AccessToken] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION
Write an Entra ID Access Token to the console with color coding.

### EXAMPLES

#### EXAMPLE 1
```
Get-EntraIDAccessToken | Write-EntraIDAccessToken
```

### PARAMETERS

#### -AccessToken


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

#### -ProgressAction


```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

### INPUTS

### OUTPUTS

### NOTES

### RELATED LINKS
