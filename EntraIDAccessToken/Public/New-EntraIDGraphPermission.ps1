<#
.SYNOPSIS
Creates new Microsoft Graph permissions for an application.

.DESCRIPTION
Creates new Microsoft Graph permissions for an application by assigning app roles from the Microsoft Graph service principal to the specified application object.

.EXAMPLE
New-EntraIDGraphPermission -GraphPermission "User.Read.All","Group.Read.All" -ObjectId "your-enterprise-application-object-id"
#>
function New-EntraIDGraphPermission {
    [CmdletBinding(SupportsShouldProcess = $true)]

    Param(
        [Parameter(Mandatory = $true)]
        [String[]] $GraphPermission,

        [Parameter(Mandatory = $true)]
        [String] $ObjectId,

        [Parameter(Mandatory = $false)]
        [String] $AccessTokenProfile = "Default"
    )

    Process {
        if (!(Get-EntraIDAccessTokenProfile -Profile $AccessTokenProfile)) {
            Write-Output "No access token profile found. Starting interactive sign-in."
            Add-EntraIDInteractiveUserAccessTokenProfile -Name $AccessTokenProfile
        }
        
        # Ensure permissions
        if (!(Get-EntraIDAccessToken -Profile $AccessTokenProfile | Get-EntraIDAccessTokenHasScopes -Scopes "application.readwrite.all", "application.read.all" -Any)) {
            throw "The access token profile '$AccessTokenProfile' does not have the required permissions to assign application roles. Please ensure it has 'Application.ReadWrite.All' or 'Application.Read.All' permissions."
        }

        # Get Microsoft Graph service principal
        $Graph = Invoke-RestMethod -Uri 'https://graph.microsoft.com/v1.0/servicePrincipals(appId=''00000003-0000-0000-c000-000000000000'')' -Headers (Get-EntraIDAccessTokenHeader -Profile $AccessTokenProfile)
        Write-Output "Found Microsoft Graph service principal $($Graph.displayName) with objectid $($Graph.id)"

        # Build map of app roles
        $GraphAppRoles = Invoke-RestMethod -Uri 'https://graph.microsoft.com/v1.0/servicePrincipals(appId=''00000003-0000-0000-c000-000000000000'')/appRoles?$top=999' -Headers (Get-EntraIDAccessTokenHeader -Profile $AccessTokenProfile) |
        Select-Object -ExpandProperty value |
        Group-Object -AsHashTable -Property value
        Write-Output "Found a total of $($GraphAppRoles.Count) available Microsoft Graph app roles"

        $GraphPermission | ForEach-Object {
            if ($GraphAppRoles.ContainsKey($_)) {
                $id = $GraphAppRoles[$_].id
                $body = @{
                    principalId = $ObjectId
                    resourceId  = $Graph.id
                    appRoleId   = $id
                } | ConvertTo-Json
                Write-Output ""
                Write-Output "Permission $_"
                try {
                    if ($PSCmdlet.ShouldProcess("Permission $_ to object $ObjectId", "Assign")) {
                        Write-Debug "Sending request body to uri https://graph.microsoft.com/v1.0/servicePrincipals/$($Graph.id)/appRoleAssignments: $body"
                        $r = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$($Graph.id)/appRoleAssignments" -Method POST -Body $body -Headers (Get-EntraIDAccessTokenHeader -Profile $AccessTokenProfile) -ContentType "application/json"
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
                Write-Warning "Graph app role $($_) not found"
            }
        }
    }
}