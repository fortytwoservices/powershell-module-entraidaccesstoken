<#
.SYNOPSIS
Gets the Entra ID Access Token profile(s).

.DESCRIPTION
Gets the Entra ID Access Token profile(s). This can be useful in order to see which resources, tenant IDs, client IDs and authentication methods are used.

.EXAMPLE
    PS> Get-EntraIDAccessTokenProfile

.EXAMPLE
    PS> Get-EntraIDAccessTokenProfile -Profile "API"
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
            @{L="V2Token";E={$_.Value.V2Token}},
            @{L="Thumbprint";E={$_.Value.Thumbprint}}
    }
}