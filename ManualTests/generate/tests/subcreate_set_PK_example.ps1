Import-Module secureboot
$d = (pwd).Path

###############################################################################
# Complete the following parameters
###############################################################################

$toolspath += $d + "\..\..\..\tools"
$env:path = $env:path + ";" + $toolspath

$certname = "PK"
$certpath = $d + "\..\TestCerts\PK\" + $certname + ".cer"
$sigowner = "55555555-5555-5555-5555-555555555555"

$var = "PK"
$efi_guid = "{8BE4DF61-93CA-11d2-AA0D-00E098032B8C}"
$append = $false

$signedBy = $d + "\..\TestCerts\PK\PK.pfx"
$password = ""

###############################################################################
# Everything else is calculated
###############################################################################

# Workaround relative path bug
$siglist = $certname + "_SigList.bin"
$serialization = $certname + "_SigList_Serialization_for_" + $var + ".bin"
$signature = $serialization + ".p7"
if ($append -eq $false) 
{ 
    $appendstring = "set_" 
    $attribute = "0x27"
} else 
{   
    $appendstring = "append_" 
    $attribute = "0x67"
}
$example = "Example_SetVariable_Data-" + $certname + "_" + $appendstring + $var + ".bin" 


Format-SecureBootUEFI -Name $var -SignatureOwner $sigowner -ContentFilePath $siglist -FormatWithCert -Certificate $certpath -SignableFilePath $serialization -Time 2011-05-21T13:30:00Z -AppendWrite:$append

signtool.exe sign /fd sha256 /p7 .\ /p7co 1.2.840.113549.1.7.1 /p7ce DetachedSignedData /a /f $signedBy $password $serialization

Set-SecureBootUEFI -Name $var -Time 2011-05-21T13:30:00Z -ContentFilePath $siglist -SignedFilePath $signature -OutputFilePath $example -AppendWrite:$append

if (Test-Path ($toolspath + "\authvar.exe")) {
    Trace-Command NativeCommandParameterBinder { authvar.exe $var $efi_guid $attribute $example $siglist } -PsHost
}
