<#
.Synopsis
    Creates a base64 string of a default JWT header, with certificate information
.DESCRIPTION
    Creates a base64 string of a default JWT header, with certificate information
.EXAMPLE
    Get-AppendedSignature -InputString "base64header.base64payload" -Kid "https://kv.vault.azure.net/keys/abc/xxx" -KeyVaultHeaders @{...}
#>
function Get-AppendedSignature {
    [CmdletBinding()]
 
    param (
        [Parameter(Mandatory = $true)] [String] $InputString,
 
        [Parameter(Mandatory = $true)] [System.Security.Cryptography.X509Certificates.X509Certificate2] $Certificate
    )
 
    Process {
        # Hash it with SHA-256:
        $hasher = [System.Security.Cryptography.HashAlgorithm]::Create('sha256')
        $hash = $hasher.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($InputString))
         
        # Use certificate to sign hash
        $signature = $Certificate.PrivateKey.SignHash($hash, 'SHA256', [System.Security.Cryptography.RSASignaturePadding]::Pkcs1)
         
        # Create full JWT with the signature we got from KeyVault (just append .SIGNATURE)
        return $InputString + "." + [System.Convert]::ToBase64String($signature)
    }
}