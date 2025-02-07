# Documentation for module EntraIDAccessToken

A module for simplifying the process of getting an access token from Entra ID

| Metadata | Information |
| --- | --- |
| Version | 2.5.0 |
| Author | Marius Solbakken Mellum |
| Company name | Fortytwo Technologies AS |
| PowerShell version | 7.1 |

## Add-EntraIDAutomationAccountMSIAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

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
## Add-EntraIDAzureDevOpsFederatedCredentialAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

### SYNTAX

#### Default (Default)
```
Add-EntraIDAzureDevOpsFederatedCredentialAccessTokenProfile [-Name <String>] [-Resource <String>]
 -TenantId <String> -ClientId <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### v2
```
Add-EntraIDAzureDevOpsFederatedCredentialAccessTokenProfile [-Name <String>] [-Scope <String>]
 -TenantId <String> -ClientId <String> [-V2Token] [-ProgressAction <ActionPreference>] [<CommonParameters>]
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
Parameter Sets: Default
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
Parameter Sets: v2
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
## Add-EntraIDClientCertificateAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

### SYNTAX

#### x509certificate2 (Default)
```
Add-EntraIDClientCertificateAccessTokenProfile [-Name <String>] [-Resource <String>] [-Scope <String>]
 -Certificate <X509Certificate2> -ClientId <String> -TenantId <String> [-TokenVersion <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### thumbprint
```
Add-EntraIDClientCertificateAccessTokenProfile [-Name <String>] [-Resource <String>] [-Scope <String>]
 -Thumbprint <String> -ClientId <String> -TenantId <String> [-TokenVersion <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### pfx
```
Add-EntraIDClientCertificateAccessTokenProfile [-Name <String>] [-Resource <String>] [-Scope <String>]
 -Path <String> -Password <SecureString> -ClientId <String> -TenantId <String> [-TokenVersion <String>]
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

#### -Scope


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Https://graph.microsoft.com/.default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -Certificate


```yaml
Type: X509Certificate2
Parameter Sets: x509certificate2
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
Parameter Sets: thumbprint
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
Parameter Sets: pfx
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
Parameter Sets: pfx
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

#### v1 (Default)
```
Add-EntraIDClientSecretAccessTokenProfile [-Name <String>] [-Resource <String>] -TenantId <String>
 -ClientSecret <SecureString> -ClientId <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### v2
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
Parameter Sets: v1
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
Parameter Sets: v2
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
Parameter Sets: v2
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
## Add-EntraIDExternalAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

### SYNTAX

```
Add-EntraIDExternalAccessTokenProfile [[-Name] <String>] [-AccessToken] <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
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
Position: 1
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

#### -AccessToken


```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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

```
Add-EntraIDGitHubFederatedCredentialAccessTokenProfile [-Name <String>] [-Resource <String>] [-Scope <String>]
 -TenantId <String> -ClientId <String> [-V2Token] [-ProgressAction <ActionPreference>] [<CommonParameters>]
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
Parameter Sets: (All)
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
## Get-EntraIDAccessToken

### SYNOPSIS
Gets an access token from Entra ID for the configured profile

### SYNTAX

```
Get-EntraIDAccessToken [[-Profile] <String>] [-ForceRefresh] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Get-EntraIDAccessToken
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
Decodes an input access token and returns the payload as a PowerShell object

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


### EXAMPLES

#### EXAMPLE 1
```
Get-EntraIDAccessToken | Compare-EntraIDAccessTokenRoles -Roles "Group.Create","AdministrativeUnit.Read.All"
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
## Get-EntraIDAccessTokenHeader

### SYNOPSIS
Uses the configured credentials for getting an access token for the Inbound Provisioning API.
Internal helper method.

### SYNTAX

```
Get-EntraIDAccessTokenHeader [[-Profile] <String>] [-ConsistencyLevelEventual]
 [[-AdditionalHeaders] <Hashtable>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Get-EntraIDAccessTokenHeader
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
Decodes an input access token and returns the payload as a PowerShell object

### SYNTAX

```
Get-EntraIDAccessTokenPayload [-InputObject] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
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
Gets an access token from Entra ID for the configured profile

### SYNTAX

```
Get-EntraIDAccessTokenProfile [[-Profile] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Get-EntraIDAccessTokenProfile
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
