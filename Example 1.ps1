Import-Module ./EntraIDAccessToken -Force -Verbose

# Add client secret profile
$ClientSecret = Read-Host -AsSecureString
Add-EntraIDAccessTokenProfile -ClientSecret $ClientSecret -TenantId "237098ae-0798-4cf9-a3a5-208374d2dcfd" -ClientId "179ba868-8e81-4bcb-b8e4-a3268fe8b13d"

# Get the access token from the default profile and decode the payload
Get-EntraIDAccessToken -Profile Default | Get-EntraIDAccessTokenPayload

# Get the access token from the default profile and use it to get the users from the Microsoft Graph API
Invoke-RestMethod "https://graph.microsoft.com/v1.0/users" -Headers (Get-EntraIDAccessTokenHeader)