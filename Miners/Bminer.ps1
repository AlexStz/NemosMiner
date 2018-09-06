if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}
 
$Path = ".\Bin\NVIDIA-Bminer\bminer.exe"
$Uri = "https://www.bminercontent.com/releases/bminer-lite-v10.1.0-1323b4f-amd64.zip"
$Commands = [PSCustomObject]@{
    "equihashBTG" = " -uri zhash://" #Equihash(testing)
    "equihash" = " -uri stratum://" #Equihash(testing)
}
$Port = $Variables.NVIDIAMinerAPITCPPort
$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "$($Commands.$_)$($Pools.(Get-Algorithm($_)).User):$($Pools.(Get-Algorithm($_)).Pass.ToString().replace(',','%2C'))@$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -max-temperature 94 -devices $($Config.SelGPUCC) -api 127.0.0.1:$Port -nofee"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Week} 
        API = "Wrapper"
        Port = $Port
        Wrap = $true
        URI = $Uri    
        User = $Pools.(Get-Algorithm($_)).User
    }
}
