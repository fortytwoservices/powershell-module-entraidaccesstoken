# Documentation for module EntraIDAccessToken

A module for simplifying the process of getting an access token from Entra ID

| Metadata | Information |
| --- | --- |
| Version | 1.1.0 |
| Author | Marius Solbakken Mellum |
| Company name | Fortytwo Technologies AS |
| PowerShell version | 7.1 |

## Add-EntraIDAccessTokenProfile

### SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

### SYNTAX

#### clientsecret (Default)
```
Add-EntraIDAccessTokenProfile [-Profile <String>] [-Resource <String>] -TenantId <String>
 -ClientSecret <SecureString> -ClientId <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### interactive
```
Add-EntraIDAccessTokenProfile [-Profile <String>] [-Resource <String>] [-TenantId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### azuredevopsfederatedcredential
```
Add-EntraIDAccessTokenProfile [-Profile <String>] [-Resource <String>] -TenantId <String> -ClientId <String>
 [-AzureDevOpsFederatedCredential] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### accesstoken
```
Add-EntraIDAccessTokenProfile [-Profile <String>] [-Resource <String>] [-AccessToken <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

#### automationaccountmsi
```
Add-EntraIDAccessTokenProfile [-Profile <String>] [-Resource <String>] [-TrustingApplicationClientId <String>]
 [-ClientId <String>] [-AutomationAccountManagedServiceIdentity] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### DESCRIPTION


### EXAMPLES

#### EXAMPLE 1
```
Add-EntraIDAccessTokenProfile
```

### PARAMETERS

#### -Profile


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
Parameter Sets: clientsecret, azuredevopsfederatedcredential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: interactive
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ClientSecret


```yaml
Type: SecureString
Parameter Sets: clientsecret
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -AccessToken


```yaml
Type: String
Parameter Sets: accesstoken
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -TrustingApplicationClientId


```yaml
Type: String
Parameter Sets: automationaccountmsi
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -ClientId


```yaml
Type: String
Parameter Sets: clientsecret, azuredevopsfederatedcredential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: automationaccountmsi
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#### -AutomationAccountManagedServiceIdentity
Switch parameter used for specifying the authentication method (used only to set the parameter set)

```yaml
Type: SwitchParameter
Parameter Sets: automationaccountmsi
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

#### -AzureDevOpsFederatedCredential
Switch parameter used for specifying the authentication method (used only to set the parameter set)

```yaml
Type: SwitchParameter
Parameter Sets: azuredevopsfederatedcredential
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
## Get-EntraIDAccessTokenHeader

### SYNOPSIS
Uses the configured credentials for getting an access token for the Inbound Provisioning API.
Internal helper method.

### SYNTAX

```
Get-EntraIDAccessTokenHeader [[-Profile] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
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
