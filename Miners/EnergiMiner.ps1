if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}

$Path = ".\Bin\NVIDIA-EnergiMiner221\energiminer.exe"
$Uri = "https://nemosminer.com/data/optional/energiminer-2.2.1-Windows.7z"

$Commands = [PSCustomObject]@{
    #"nrghash"        = "" #Nrghash (testing)
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = "-cuda-devices --devices $($Config.SelGPUDSTM) stratum+tcp://$($Pools.(Get-Algorithm($_)).User):c=BTC@nrghash.mine.zergpool.com:3100 -U --response-timeout 10 --cuda-parallel-hash 8 --cuda-block-size 256"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
        API       = "ccminer"
        Port      = $Variables.NVIDIAMinerAPITCPPort
        Wrap      = $false
        URI       = $Uri
        User      = $Pools.(Get-Algorithm($_)).User
    }
}
