Import-Module ./EntraIDAccessToken -Force -Verbose

# Access Token read from some other source. Not useful for anything other than debugging and testing purposes.
$AccessToken = "ey..."
Add-EntraIDAccessTokenProfile -AccessToken $AccessToken
Get-EntraIDAccessToken -Profile Default