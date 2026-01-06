<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDAccessTokenProfile

#>
function Add-EntraIDClientCertificateAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName = "x509certificate2-resource")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $false, ParameterSetName = "x509certificate2-resource")]
        [Parameter(Mandatory = $false, ParameterSetName = "pfx-resource")]
        [Parameter(Mandatory = $false, ParameterSetName = "thumbprint-resource")]
        [String] $Resource = "https://graph.microsoft.com",

        [Parameter(Mandatory = $true, ParameterSetName = "x509certificate2-scope")]
        [Parameter(Mandatory = $true, ParameterSetName = "thumbprint-scope")]
        [Parameter(Mandatory = $true, ParameterSetName = "pfx-scope")]
        [String] $Scope,

        [Parameter(Mandatory = $true, ParameterSetName = "x509certificate2-resource")]
        [Parameter(Mandatory = $true, ParameterSetName = "x509certificate2-scope")]
        [System.Security.Cryptography.X509Certificates.X509Certificate2] $Certificate,

        [Parameter(Mandatory = $true, ParameterSetName = "thumbprint-resource")]
        [Parameter(Mandatory = $true, ParameterSetName = "thumbprint-scope")]
        [String] $Thumbprint,

        [Parameter(Mandatory = $true, ParameterSetName = "pfx-resource")]
        [Parameter(Mandatory = $true, ParameterSetName = "pfx-scope")]
        [String] $Path,

        [Parameter(Mandatory = $true, ParameterSetName = "pfx-resource")]
        [Parameter(Mandatory = $true, ParameterSetName = "pfx-scope")]
        [SecureString] $Password,

        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId,

        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $TenantId,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("v1", "v2")]
        [String] $TokenVersion = "v1",

        [Parameter(Mandatory = $false, ParameterSetName = "pfx-scope")]
        [Parameter(Mandatory = $false, ParameterSetName = "thumbprint-scope")]
        [Parameter(Mandatory = $false, ParameterSetName = "x509certificate2-scope")]
        [String] $FMIPath
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey('TokenVersion')) {
            Write-Warning "TokenVersion is a deprecated parameter and will be removed in future releases"
        }

        if ($PSCmdlet.MyInvocation.BoundParameters['Resource'] -and $PSCmdlet.MyInvocation.BoundParameters['Scope']) {
            throw "Cannot specify both Resource and Scope"
        }

        $Certificate = $null;

        if ($PSCmdlet.ParameterSetName -like "x509certificate2-*") {
            
        }
        elseif ($PSCmdlet.ParameterSetName -like "thumbprint-*") {
            $localmachine = Get-ChildItem Cert:\LocalMachine\My | Where-Object ThumbPrint -eq $Thumbprint | Select-Object -First 1
            $currentuser = Get-ChildItem Cert:\CurrentUser\My | Where-Object ThumbPrint -eq $Thumbprint | Select-Object -First 1

            if ($localmachine) {
                $Certificate = $localmachine
            }
            elseif ($currentuser) {
                $Certificate = $currentuser
            }
            else {
                throw "Certificate with thumbprint $Thumbprint not found"
            }
        }
        elseif ($PSCmdlet.ParameterSetName -like "pfx-*") {
            if (!(Test-Path $Path)) {
                throw "Path $Path does not exist"
            }

            $Certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($Path, $Password, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::UserKeySet)
        }

        if (!$Certificate) {
            throw "Certificate not found"
        }

        if (!$Certificate.HasPrivateKey) {
            throw "Certificate $($Certificate.Thumbprint) does not have a private key"
        }
        
        Write-Verbose "Certificate thumbprint: $($Certificate.Thumbprint)"
        Write-Verbose "Certificate subject: $($Certificate.Subject)"
        Write-Verbose "Certificate not valid after: $($Certificate.NotAfter)"
        Write-Verbose "Certificate not valid before: $($Certificate.NotBefore)"

        $Script:Profiles[$Name] = @{
            AuthenticationMethod = "clientcertificate"
            ClientId             = $ClientId
            Resource             = ![String]::IsNullOrEmpty($Scope) ? $null : $Resource
            Scope                = [String]::IsNullOrEmpty($Scope) ? $null : $Scope
            TenantId             = $TenantId
            Certificate          = $Certificate
            ThumbPrint           = $Certificate.Thumbprint
            FMIPath              = $PSCmdlet.MyInvocation.BoundParameters.ContainsKey("FMIPath") ? $FMIPath : $null
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
