if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}

$Path = ".\Bin\NVIDIA-CryptoDredge0180\CryptoDredge.exe"
$Uri = "https://github.com/technobyl/CryptoDredge/releases/download/v0.18.0/CryptoDredge_0.18.0_cuda_10.0_windows.zip"

$Commands = [PSCustomObject]@{
     "argon2ddyn"        = " --intensity 5 -a argon2d" #Argon2d-dyn
     "allium"            = " --intensity 7 -a allium" #Allium
     "lyra2v3"           = " --intensity 7 -a lyra2v3" #Lyra2v3
     "lyra2REv3"         = " --intensity 7 -a lyra2v3" #lyra2REv3
     "lyra2zz "          = " --intensity 7 -a lyra2zz" #Lyra2zz
     "neoscrypt"         = " --intensity 5 -a neoscrypt"
     "phi"               = " --intensity 7 -a phi" #Phi
     "phi2"              = " --intensity 6 -a phi2" #Phi2 
     "lyra2vc0ban"       = " --intensity 7 -a lyra2vc0ban" #Lyra2vc0banHash
    #"cryptonightheavy"  = " --intensity 7 -a cryptonightheavy" # CryptoNightHeavy
    #"x22i"              = " --intensity 7 -a x22i" # X22i 
    #"tribus"            = " --intensity 7 -a tribus" #Tribus 
    #"cnv8"              = " --intensity 7 -a cnv8" #CryptoNightv8
    #"c11"               = " --intensity 7 -a c11" #C11 
     "skunk"             = " --intensity 7 -a skunk" #Skunk 
     "mtp"               = " --intensity 7 -a mtp" #Mtp
    #"bcd"               = " --intensity 7 -a bcd" #Bcd 
    #"x16rt"             = " --intensity 7 -a x16rt" #X16rt
    #"x21s"              = " --intensity 7 -a x21s" #X21s 
    #"x16s"              = " --intensity 7 -a x16s" #X16s 
    #"x17"               = " --intensity 7 -a x17" #X17 
    #"bitcore"           = " --intensity 7 -a bitcore" #Bitcore 
     "hmq1725"           = " --intensity 7 -a hmq1725" #Hmq1725
    #"dedal"             = " --intensity 7 -a dedal" #Dedal
     "pipe"              = " --intensity 7 -a pipe" #Pipe 
    #"x16r"              = " --intensity 7 -a x16r" #x16r
     "grincuckaroo29"    = " --intensity 6 -a cuckaroo29" #Grincuckaroo29
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    $Algo = Get-Algorithm($_)
    switch ($_) {
        "mtp" {$Fee = 0.02}
        default {$Fee = 0.01}
    }

    [PSCustomObject]@{
        Type      = "NVIDIA"
        Path      = $Path
        Arguments = "--no-nvml --api-type ccminer-tcp --cpu-priority 4 --no-crashreport --no-watchdog -r -1 -R 1 -b 127.0.0.1:$($Variables.NVIDIAMinerAPITCPPort) -d $($Config.SelGPUCC) -o stratum+tcp://$($Pools.($Algo).Host):$($Pools.($Algo).Port) -u $($Pools.($Algo).User) -p $($Pools.($Algo).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{($Algo) = $Stats."$($Name)_$($Algo)_HashRate".Day * (1 - $Fee)} # substract 1% devfee
        API       = "ccminer"
        Port      = $Variables.NVIDIAMinerAPITCPPort
        Wrap      = $false
        URI       = $Uri
        User = $Pools.($Algo).User
        Host = $Pools.($Algo).Host
        Coin = $Pools.($Algo).Coin
    }
}
