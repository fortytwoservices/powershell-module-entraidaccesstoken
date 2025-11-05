<#
.Synopsis
    Creates a signed JWT of the Payload
.DESCRIPTION
    Creates a signed JWT of the Payload
.EXAMPLE
    Get-SignedJWT -Payload @{sub="abc"} -Certificate $cert
#>
function Get-SignedJWT {
    [CmdletBinding()]
 
    param (
        [Parameter(Mandatory = $true)] [System.Collections.Hashtable] $Payload,
 
        [Parameter(Mandatory = $true)] $Certificate,
 
        [Parameter(Mandatory = $false)] [Boolean] $DoNotAddJtiClaim = $false
    )
 
    Process {
        # Build our JWT header
        $JWTHeader = Get-JWTHeader -Certificate $certificate
 
        # Set EXP to unixtime
        if (!$Payload.ContainsKey("exp")) {
            $Payload["exp"] = [int] ((Get-Date).AddHours(1).ToUniversalTime() - [datetime]'1970-01-01T00:00:00Z').TotalSeconds # Unixtime + 3600
        }
        elseif ($Payload["exp"].GetType().Name -eq "DateTime") {
            $Payload["exp"] = [int] ((Get-Date -Date ($Payload["exp"]).ToUniversalTime() - [datetime]'1970-01-01T00:00:00Z').TotalSeconds) # Unixtime
        }
        else {
            $Payload["exp"] = [int] ((Get-Date).AddHours(1).ToUniversalTime() - [datetime]'1970-01-01T00:00:00Z').TotalSeconds # Unixtime + 3600
        }
 
        # Set EXP to unixtime
        if (!$Payload.ContainsKey("nbf")) {
            $Payload["nbf"] = [int] ((Get-Date).ToUniversalTime() - [datetime]'1970-01-01T00:00:00Z').TotalSeconds # Unixtime
        }
        elseif ($Payload["nbf"].GetType().Name -eq "DateTime") {
            $Payload["nbf"] = [int] (Get-Date -Date ($Payload["nbf"]).ToUniversalTime()  - [datetime]'1970-01-01T00:00:00Z') # Unixtime
        }
        else {
            $Payload["nbf"] = [int] ((Get-Date).ToUniversalTime() - [datetime]'1970-01-01T00:00:00Z').TotalSeconds # Unixtime
        }
 
        # Add jti if missing
        if (!$Payload.ContainsKey("jti") -and !$DoNotAddJtiClaim) {
            $Payload["jti"] = [guid]::NewGuid().ToString()
        }
 
        # Add iat
        $Payload["iat"] = [int] ((Get-Date).ToUniversalTime() - [datetime]'1970-01-01T00:00:00Z').TotalSeconds # Unixtime
         
        # Build our JWT Payload
        $JWTPayload = $Payload | ConvertTo-Json -Depth 5 -Compress
         
        # Create JWT without signature (base64 of header DOT base64 of payload)
        function ConvertTo-Base64($String) { [System.Convert]::ToBase64String(([System.Text.Encoding]::UTF8.GetBytes($String))) }
        $JWTWithoutSignature = $JWTHeader + "." + ((ConvertTo-Base64 $JWTPayload) -replace "=+$")
         
        Get-AppendedSignature -InputString $JWTWithoutSignature -Certificate $Certificate
    }
}