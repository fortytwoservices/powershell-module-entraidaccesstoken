<#
.SYNOPSIS
Lists the available app permissions for an application

.DESCRIPTION
Lists the available app permissions for an application

.EXAMPLE
Get-EntraIDAppPermission -ResourceApplicationId "2808f963-7bba-4e66-9eee-82d0b178f408"
#>
function Get-EntraIDAppPermission {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $false)]
        [String] $ResourceApplicationId = "00000003-0000-0000-c000-000000000000", # Microsoft Graph

        [Parameter(Mandatory = $false)]
        [String] $AccessTokenProfile = "Default"
    )

    Process {
        if (!(Get-EntraIDAccessTokenProfile -Profile $AccessTokenProfile)) {
            Write-Output "No access token profile found. Starting interactive sign-in."
            Add-EntraIDInteractiveUserAccessTokenProfile -Name $AccessTokenProfile -Scope "https://graph.microsoft.com/application.read.all approleassignment.readwrite.all"
        }
        
        # Ensure permissions
        if (!(Get-EntraIDAccessToken -Profile $AccessTokenProfile | Get-EntraIDAccessTokenHasScopes -Scopes "application.readwrite.all", "application.read.all" -Any)) {
            throw "The access token profile '$AccessTokenProfile' does not have the required permissions to assign application roles. Please ensure it has 'Application.ReadWrite.All' or 'Application.Read.All' permissions."
        }

        # Get Microsoft Graph service principal
        $Resource = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/servicePrincipals(appId='$ResourceApplicationId')" -Headers (Get-EntraIDAccessTokenHeader -Profile $AccessTokenProfile)
        if(!$Resource) {
            throw "Could not find the resource application with application id $ResourceApplicationId"
        }
        Write-Output "Found resource service principal $($Resource.displayName) with objectid $($Resource.id)"

        # Build map of app roles
        Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/servicePrincipals(appId='$ResourceApplicationId')/appRoles?`$top=999" -Headers (Get-EntraIDAccessTokenHeader -Profile $AccessTokenProfile) | 
        Select-Object -ExpandProperty value |
        Where-Object allowedMemberTypes -contains "Application" |
        Where-Object isEnabled |
        Select-Object id, displayName, description, value         
    }
}