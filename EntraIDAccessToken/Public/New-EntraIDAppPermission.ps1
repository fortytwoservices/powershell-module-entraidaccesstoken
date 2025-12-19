<#
.SYNOPSIS
Assigns new permissions to a service principal

.DESCRIPTION
Assigns new permissions to a service principal, such as assigning the user.read.all Graph permission to an enterprise application.

.EXAMPLE
New-EntraIDAppPermission -Permission "User.Read.All","Group.Read.All" -ObjectId "your-enterprise-application-object-id"

.EXAMPLE
New-EntraIDAppPermission -Permission "User.Read.All","Group.Read.All" -ObjectId "your-enterprise-application-object-id" -ResourceApplicationId "2808f963-7bba-4e66-9eee-82d0b178f408"
#>
function New-EntraIDAppPermission {
    [CmdletBinding(SupportsShouldProcess = $true)]

    Param(
        [Parameter(Mandatory = $true)]
        [String[]] $Permission,

        [Parameter(Mandatory = $true)]
        [String] $ObjectId,

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
        $ResourceAppRoles = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/servicePrincipals(appId='$ResourceApplicationId')/appRoles?`$top=999" -Headers (Get-EntraIDAccessTokenHeader -Profile $AccessTokenProfile) |
        Select-Object -ExpandProperty value |
        Group-Object -AsHashTable -Property value
        
        Write-Output "Found a total of $($ResourceAppRoles.Count) available app roles for the resource"
        $ResourceAppRoles.Keys | ForEach-Object {
            Write-Verbose "Available app role: $_"
        }

        $Permission | ForEach-Object {
            if ($ResourceAppRoles.ContainsKey($_)) {
                $id = $ResourceAppRoles[$_].id
                $body = @{
                    principalId = $ObjectId
                    resourceId  = $Resource.id
                    appRoleId   = $id
                } | ConvertTo-Json
                Write-Output ""
                Write-Output "Permission $_"
                try {
                    if ($PSCmdlet.ShouldProcess("Permission $_ to object $ObjectId", "Assign")) {
                        Write-Debug "Sending request body to uri https://graph.microsoft.com/v1.0/servicePrincipals/$($Resource.id)/appRoleAssignments: $body"
                        $r = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$($Resource.id)/appRoleAssignments" -Method POST -Body $body -Headers (Get-EntraIDAccessTokenHeader -Profile $AccessTokenProfile) -ContentType "application/json"
                        if ($r.id) {
                            Write-Output " ✅ New assignment was created"
                        }
                    }                    
                }
                catch {
                    if ($_.ErrorDetails.Message -like "*already exists*") {
                        Write-Output " ✅ Already exists"
                    }
                    else {
                        Write-Error "Unhandled exception while assigning permission: $_"
                    }
                }
            }
            else {
                Write-Warning "App role $($_) not found"
            }
        }
    }
}