# Prior to script execution, run "Set-ExecutionPolicy Bypass -Force"

###############################################################################
# Complete the following parameters
###############################################################################

$d = (pwd).Path
$toolspath += $d + "\..\..\..\tools"
$env:path = $env:path + ";" + $toolspath

$sigowner = "00000000-0000-0000-0000-000000000000"
$certpath = $d + "\..\TestCerts\Lost\Lost_CA.cer"
$name = "LostCA" 

$efi_guid = "`{d719b2cb-3d3a-4596-a3bc-dad00e67656f`}"
$append = $true
$signedBy = $d + "\..\TestCerts\KEK\Fabrikam_Test_KEK.pfx"
$password = ""

if ($append -eq $false) 
{ 
    $appendstring = "set_" 
    $attribute = "0x27"
} else 
{   
    $appendstring = "append_" 
    $attribute = "0x67"
}

$SigList = $name + "_SigList.bin"
$serialization = $name + "_SigList_Serialization_for_db.bin"
$signature = $serialization + ".p7"
$example = "Example_SetVariable_Data-" + $name + "_" + $appendstring + "db.bin" 

Format-SecureBootUEFI -SignatureOwner $sigowner -ContentFilePath $siglist -FormatWithCert -Certificate $certpath -SignableFilePath $serialization -Time 2011-05-21T13:30:00Z -AppendWrite:$append -Name db

signtool.exe sign /fd sha256 /p7 .\ /p7co 1.2.840.113549.1.7.1 /p7ce DetachedSignedData /a /u "1.3.6.1.4.1.311.79.2.1" /f $signedBy $password .\$serialization

# Enroll LostCA into allow "db"
Set-SecureBootUEFI -Name db -AppendWrite:$append -Time 2011-05-21T13:30:00Z -ContentFilePath $siglist -SignedFilePath $signature -OutputFilePath $example

# Verify the output
if (Test-Path ($toolspath + "\authvar.exe")) {
   Trace-Command NativeCommandParameterBinder { 
       authvar.exe db $efi_guid $attribute $example $SigList
   } -PsHost
}
