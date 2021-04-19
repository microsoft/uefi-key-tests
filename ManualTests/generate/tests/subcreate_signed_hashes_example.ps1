# Prior to script execution, run "Set-ExecutionPolicy Bypass -Force"
Import-Module secureboot
$d = (pwd).Path

###############################################################################
# Complete the following parameters
###############################################################################

$toolspath += $d + "\..\..\..\tools"
$env:path = $env:path + ";" + $toolspath

$certname = "pressAnyKey2_hashes"
$sigowner = "00000000-0000-0000-0000-000000000000"

# hashes for amd64, arm, x86
$hashes = "3D966EA29637A05C7508B1EFCB7CF0058980A74AE3647217AB26E7D2C3FE50FC",
          "D3B5CFDA516ACF4F53CCB4EF6601CA26EE6416F007AFF0C9722E3878825C7D67",
          "C6D3EB143A3EB36F401FD9E8D3842A996429CC8ABAAC8C550A5251166D08CB1F" 

$var = "dbx"
$efi_guid = "`{d719b2cb-3d3a-4596-a3bc-dad00e67656f`}"
$time = "2011-05-21T13:31:00z"
$signedBy = $d + "\..\TestCerts\KEK\Fabrikam_Test_KEK.pfx"
$password = ""

###############################################################################
# Everything else is calculated
###############################################################################

# Always append for dbx
$append = $true
$appendstring = "append_" 
$attribute = "0x67"

$SigList = $certname + "_SigList.bin"
$serialization = $certname + "_SigList_Serialization_for_" + $var + ".bin"
$signature = $serialization + ".p7"
$example = "Example_SetVariable_Data-" + $certname + "_" + $appendstring + $var + ".bin" 

Format-SecureBootUEFI -Name $var -SignatureOwner $sigowner -Hash $hashes -Algorithm sha256 -ContentFilePath $siglist -SignableFilePath $serialization -Time $time -AppendWrite:$append 

signtool.exe sign /fd sha256 /p7 .\ /p7co 1.2.840.113549.1.7.1 /p7ce DetachedSignedData /a /u "1.3.6.1.4.1.311.79.2.1" /f $signedBy $password $serialization

Set-SecureBootUEFI -Time $time -ContentFilePath $siglist -SignedFilePath $signature -OutputFilePath $example -Name $var -AppendWrite:$append


if (Test-Path ($toolspath + "\authvar.exe")) {
    Trace-Command NativeCommandParameterBinder { authvar.exe dbx $efi_guid $attribute $example $SigList } -PsHost
}
