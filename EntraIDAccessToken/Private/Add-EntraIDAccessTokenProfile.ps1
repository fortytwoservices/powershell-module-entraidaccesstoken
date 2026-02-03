function Add-EntraIDAccessTokenProfile {
    [CmdletBinding(DefaultParameterSetName = "default")]

    Param(
        [Parameter(Mandatory = $true)]
        $Name,

        [Parameter(Mandatory = $false)]
        [System.Collections.Hashtable] $Profile
    )

    Process {
           $Script:Profiles[$Name] = $Profile


           if($Script:TokenCache.Count -eq 0) {
               return
           }
           
           $CacheToRemove = @()
           $Script:TokenCache.Keys | Where-Object {$_.StartsWith("$Name:::")} | ForEach-Object {
               $CacheToRemove += $_
           }
           foreach ($Key in $CacheToRemove) {
               $Script:TokenCache.Remove($Key) | Out-Null
           }
    }
}