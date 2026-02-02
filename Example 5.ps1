Import-Module ./EntraIDAccessToken -Force -Verbose

# Add client secret profile
$ClientSecret ??= Read-Host -AsSecureString
Add-EntraIDClientSecretAccessTokenProfile -ClientSecret $ClientSecret -TenantId "237098ae-0798-4cf9-a3a5-208374d2dcfd" -ClientId "9471f355-173a-4466-b142-3d4acf848b03" -Scope "api://AzureADTokenExchange/.default" -Name "Blueprint" -Debug

# $Blueprint = Get-EntraIDAccessToken -FMIPath "cd77c677-16ea-4f9d-b5b1-0aab1841694c" -Profile Blueprint
Add-EntraIDFederatedCredentialTokenProfile -Name "Agent 1" -TenantId "237098ae-0798-4cf9-a3a5-208374d2dcfd" -ClientId "cd77c677-16ea-4f9d-b5b1-0aab1841694c" -FederatedAccessTokenProfile Blueprint -AgentIdentity -Scope "api://AzureADTokenExchange/.default" -Debug

Add-EntraIDAgentUserTokenProfile -Name "Agent User 1" -AgentIdentityAccessTokenProfile "Agent 1" -UserPrincipalName "7acd14d47a62@dev.goodworkaround.com" -Verbose -Debug
Add-EntraIDAgentUserTokenProfile -Name "Agent User 1" -AgentIdentityAccessTokenProfile "Agent 1" -UserPrincipalName "629db438-941d-4e66-a9ef-bbe70e6cf3ac" -Verbose -Debug

