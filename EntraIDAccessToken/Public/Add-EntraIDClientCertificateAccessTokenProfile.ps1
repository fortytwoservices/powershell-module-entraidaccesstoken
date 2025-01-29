<#
.SYNOPSIS
Adds a new profile for getting Entra ID access tokens.

.EXAMPLE
Add-EntraIDAccessTokenProfile

#>
function Add-EntraIDClientCertificateAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName = "x509certificate2")]

    Param
    (
        [Parameter(Mandatory = $false)]
        [String] $Name = "Default",

        [Parameter(Mandatory = $false)]
        [String] $Resource = "https://graph.microsoft.com",

        [Parameter(Mandatory = $false)]
        [String] $Scope = "https://graph.microsoft.com/.default",

        [Parameter(Mandatory = $true, ParameterSetName = "x509certificate2")]
        [System.Security.Cryptography.X509Certificates.X509Certificate2] $Certificate,

        [Parameter(Mandatory = $true, ParameterSetName = "thumbprint")]
        [String] $Thumbprint,

        [Parameter(Mandatory = $true, ParameterSetName = "pfx")]
        [String] $Path,

        [Parameter(Mandatory = $true, ParameterSetName = "pfx")]
        [SecureString] $Password,

        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $ClientId,

        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$")]
        [String] $TenantId,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("v1", "v2")]
        [String] $TokenVersion = "v1"
    )
    
    Process {
        if ($Script:Profiles.ContainsKey($Name)) {
            Write-Warning "Profile $Name already exists, overwriting"
        }

        if($PSCmdlet.ParameterSetName -eq "x509certificate2") {
            
        } elseif($PSCmdlet.ParameterSetName -eq "thumbprint") {
            $localmachine = Get-ChildItem Cert:\LocalMachine\My | Where-Object ThumbPrint -eq $Thumbprint | Select-Object -First 1
            $currentuser = Get-ChildItem Cert:\CurrentUser\My | Where-Object ThumbPrint -eq $Thumbprint | Select-Object -First 1

            if($localmachine) {
                $Certificate = $localmachine
            } elseif($currentuser) {
                $Certificate = $currentuser
            } else {
                throw "Certificate with thumbprint $Thumbprint not found"
            }
        } elseif($PSCmdlet.ParameterSetName -eq "pfx") {
            if(!(Test-Path $Path)) {
                throw "Path $Path does not exist"
            }

            $Certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($Path, $Password)
        }

        if(!$Certificate) {
            throw "Certificate not found"
        }

        if(!$Certificate.HasPrivateKey) {
            throw "Certificate $($Certificate.Thumbprint) does not have a private key"
        }
        
        Write-Verbose "Certificate thumbprint: $($Certificate.Thumbprint)"
        Write-Verbose "Certificate subject: $($Certificate.Subject)"
        Write-Verbose "Certificate not valid after: $($Certificate.NotAfter)"
        Write-Verbose "Certificate not valid before: $($Certificate.NotBefore)"

        $Script:Profiles[$Name] = @{
            AuthenticationMethod = "clientcertificate"
            ClientId             = $ClientId
            Resource             = $Resource
            Scope                = $Scope
            TenantId             = $TenantId
            Certificate          = $Certificate
            V2Token              = $TokenVersion -eq "v2"
        }

        Get-EntraIDAccessToken -Profile $Name | Out-Null
    }
}
