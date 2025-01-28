<#
.SYNOPSIS
Gets an access token from Entra ID for the configured profile

.EXAMPLE
Get-EntraIDAccessTokenProfile

#>
function Get-EntraIDAccessTokenProfile {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory = $false)]
        [String] $Profile = "*"
    )

    Process {
        $Script:Profiles.GetEnumerator() | 
        Where-Object Key -like $Profile | 
        Select-Object `
            @{L="Name";E={$_.Key}}, 
            @{L="TenantId";E={$_.Value.TenantId}},
            @{L="Resource";E={$_.Value.Resource}},
            @{L="AuthenticationMethod";E={$_.Value.AuthenticationMethod}},
            @{L="ClientId";E={$_.Value.ClientId}},
            @{L="TrustingApplicationClientId";E={$_.Value.TrustingApplicationClientId}},
            @{L="Scope";E={$_.Value.Scope}},
            @{L="V2Token";E={$_.Value.V2Token}}
    }
}