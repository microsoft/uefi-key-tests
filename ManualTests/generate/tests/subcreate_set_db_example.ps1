Import-Module secureboot
$d = (pwd).Path

###############################################################################
# Complete the following parameters
###############################################################################

$toolspath += $d + "\..\..\..\tools"
$env:path = $env:path + ";" + $toolspath

$certpath  = , ($d + "\..\..\certs\db_MSFTproductionWindowsSigningCA2011.cer")
$certpath += , ($d + "\..\..\certs\db_MSFTproductionUEFIsigningCA.cer")
$certpath += , ($d + "\..\..\certs\test\db_MSFTpreReleaseCandidateWindowsSigningCA.cer")
$certpath += , ($d + "\..\..\certs\test\db_MSFTtestSigningRoot.cer")
$name = "signing_signatures"
$sigowner = "77fa9abd-0359-4d32-bd60-28f4e78f784b"

$var = "db"
$efi_guid = "`{d719b2cb-3d3a-4596-a3bc-dad00e67656f`}"
$append = $false
$signedBy = $d + "\..\TestCerts\KEK\Fabrikam_Test_KEK.pfx"
$password = ""

###############################################################################
# Everything else is calculated
###############################################################################

if ($append -eq $false) 
{ 
    $appendstring = "set_" 
    $attribute = "0x27"
} else 
{   
    $appendstring = "append_" 
    $attribute = "0x67"
}

$siglist = $name + "_SigList.bin"
$serialization = $name + "_SigList_Serialization_for_" + $var + ".bin"
$signature = $serialization + ".p7"
$example = "Example_SetVariable_Data-" + $name + "_" + $appendstring + $var + ".bin" 


Format-SecureBootUEFI -Name $var -SignatureOwner $sigowner -ContentFilePath $siglist -FormatWithCert -CertificateFilePath $certpath -SignableFilePath $serialization -Time 2011-05-21T13:30:00Z -AppendWrite:$append 

signtool.exe sign /fd sha256 /p7 .\ /p7co 1.2.840.113549.1.7.1 /p7ce DetachedSignedData /a /u "1.3.6.1.4.1.311.79.2.1" /f $signedBy $password $serialization

Set-SecureBootUEFI -Name $var -Time 2011-05-21T13:30:00Z -ContentFilePath $siglist -SignedFilePath $signature -OutputFilePath $example -AppendWrite:$append

if (Test-Path ($toolspath + "\authvar.exe")) {
    Trace-Command NativeCommandParameterBinder { authvar.exe $var $efi_guid $attribute $example $siglist } -PsHost
}

