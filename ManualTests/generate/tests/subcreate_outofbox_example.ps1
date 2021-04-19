Import-Module secureboot
$d = (pwd).Path
$toolspath += $d + "\..\..\..\tools"
$env:path = $env:path + ";" + $toolspath

###############################################################################
# PK 
# - OEM PK
###############################################################################

$var = "PK"
$efi_guid = "{8BE4DF61-93CA-11d2-AA0D-00E098032B8C}"

$name = "OEM_PK"
# TODO: replace with OEM SignatureOwner GUID
$sigowner = "55555555-5555-5555-5555-555555555555"
# TODO: replace with OEM PK
$certpath = $d + "\..\TestCerts\PK\PK.cer"

# TODO: replace with OEM PK PFX & password
$signedBy = $d + "\..\TestCerts\PK\PK.pfx"
$password = ""

$append = $false
$appendstring = "set_" 
$attribute = "0x27"

$siglist = $name + "_SigList.bin"
$serialization = $name + "_SigList_Serialization_for_" + $var + ".bin"
$signature = $serialization + ".p7"
$example = "Example_SetVariable_Data-" + $name + "_" + $appendstring + $var + ".bin" 

Format-SecureBootUEFI -Name $var -SignatureOwner $sigowner -ContentFilePath $siglist -FormatWithCert -Certificate $certpath -SignableFilePath $serialization -Time 2011-05-21T13:30:00Z

signtool.exe sign /fd sha256 /p7 .\ /p7co 1.2.840.113549.1.7.1 /p7ce DetachedSignedData /a /f $signedBy $password $serialization

# The following creates an example rather than actually setting the variable
Set-SecureBootUEFI -Name $var -Time 2011-05-21T13:30:00Z -ContentFilePath $siglist -SignedFilePath $signature -OutputFilePath $example

if (Test-Path ($toolspath + "\authvar.exe")) {
    Trace-Command NativeCommandParameterBinder { authvar.exe $var $efi_guid $attribute $example $siglist } -PsHost
}


###############################################################################
# KEK
# - Microsoft Corporation KEK CA 2011
###############################################################################

$var = "KEK"
$efi_guid = "{8BE4DF61-93CA-11d2-AA0D-00E098032B8C}"

$name = "OutOfBox_KEK"
$sigowner = "77fa9abd-0359-4d32-bd60-28f4e78f784b" #MSFT SigOwner GUID

$certpath  = , ($d + "\..\..\certs\KEK_MSFTproductionKekCA.cer")

# TODO: replace with OEM PK PFX & password
$signedBy = $d + "\..\TestCerts\PK\PK.pfx"
$password = ""

$append = $true
$appendstring = "append_" 
$attribute = "0x67"


$siglist = $name + "_SigList.bin"
$serialization = $name + "_SigList_Serialization_for_" + $var + ".bin"
$signature = $serialization + ".p7"
$example = "Example_SetVariable_Data-" + $name + "_" + $appendstring + $var + ".bin" 

Format-SecureBootUEFI -Name $var -SignatureOwner $sigowner -ContentFilePath $siglist -FormatWithCert -CertificateFilePath $certpath -SignableFilePath $serialization -Time 2011-05-21T13:30:00Z -AppendWrite:$append 

signtool.exe sign /fd sha256 /p7 .\ /p7co 1.2.840.113549.1.7.1 /p7ce DetachedSignedData /a /f $signedBy $password $serialization

Set-SecureBootUEFI -Name $var -Time 2011-05-21T13:30:00Z -ContentFilePath $siglist -SignedFilePath $signature -OutputFilePath $example -AppendWrite:$append

if (Test-Path ($toolspath + "\authvar.exe")) {
    Trace-Command NativeCommandParameterBinder { authvar.exe $var $efi_guid $attribute $example $siglist } -PsHost
}


###############################################################################
# db
# - Microsoft Windows PCA 2011
###############################################################################

$var = "db"
$efi_guid = "`{d719b2cb-3d3a-4596-a3bc-dad00e67656f`}"

$name = "OutOfBox_Windows_db"
$sigowner = "77fa9abd-0359-4d32-bd60-28f4e78f784b" #MSFT SigOwner GUID

$certpath  = , ($d + "\..\..\certs\db_MSFTproductionWindowsSigningCA2011.cer")

# TODO: replace with OEM KEK & password
$signedBy = $d + "\..\TestCerts\PK\PK.pfx"
$password = ""

$append = $true
$appendstring = "append_" 
$attribute = "0x67"

$siglist = $name + "_SigList.bin"
$serialization = $name + "_SigList_Serialization_for_" + $var + ".bin"
$signature = $serialization + ".p7"
$example = "Example_SetVariable_Data-" + $name + "_" + $appendstring + $var + ".bin" 

Format-SecureBootUEFI -Name $var -SignatureOwner $sigowner -ContentFilePath $siglist -FormatWithCert -CertificateFilePath $certpath -SignableFilePath $serialization -Time 2011-05-21T13:30:00Z -AppendWrite:$append 

signtool.exe sign /fd sha256 /p7 .\ /p7co 1.2.840.113549.1.7.1 /p7ce DetachedSignedData /a /f $signedBy $password $serialization

Set-SecureBootUEFI -Name $var -Time 2011-05-21T13:30:00Z -ContentFilePath $siglist -SignedFilePath $signature -OutputFilePath $example -AppendWrite:$append

if (Test-Path ($toolspath + "\authvar.exe")) {
    Trace-Command NativeCommandParameterBinder { authvar.exe $var $efi_guid $attribute $example $siglist } -PsHost
}



###############################################################################
# db
# - Microsoft Corporation UEFI CA 2011
###############################################################################

$var = "db"
$efi_guid = "`{d719b2cb-3d3a-4596-a3bc-dad00e67656f`}"

$name = "OutOfBox_3rdPartyUEFI_db"
$sigowner = "77fa9abd-0359-4d32-bd60-28f4e78f784b" #MSFT SigOwner GUID

$certpath = , ($d + "\..\..\certs\db_MSFTproductionUEFIsigningCA.cer")

# TODO: replace with OEM KEK & password
$signedBy = $d + "\..\TestCerts\PK\PK.pfx"
$password = ""

$append = $true
$appendstring = "append_" 
$attribute = "0x67"

$siglist = $name + "_SigList.bin"
$serialization = $name + "_SigList_Serialization_for_" + $var + ".bin"
$signature = $serialization + ".p7"
$example = "Example_SetVariable_Data-" + $name + "_" + $appendstring + $var + ".bin" 

Format-SecureBootUEFI -Name $var -SignatureOwner $sigowner -ContentFilePath $siglist -FormatWithCert -CertificateFilePath $certpath -SignableFilePath $serialization -Time 2011-05-21T13:30:00Z -AppendWrite:$append 

signtool.exe sign /fd sha256 /p7 .\ /p7co 1.2.840.113549.1.7.1 /p7ce DetachedSignedData /a /f $signedBy $password $serialization

Set-SecureBootUEFI -Name $var -Time 2011-05-21T13:30:00Z -ContentFilePath $siglist -SignedFilePath $signature -OutputFilePath $example -AppendWrite:$append

if (Test-Path ($toolspath + "\authvar.exe")) {
    Trace-Command NativeCommandParameterBinder { authvar.exe $var $efi_guid $attribute $example $siglist } -PsHost
}


###############################################################################
# Complete the following parameters
###############################################################################

$toolspath += $d + "\..\..\..\tools"
$env:path = $env:path + ";" + $toolspath

$certname = "hash"
$sigowner = "00000000-0000-0000-0000-000000000000"

$hashObject = new-object System.Security.Cryptography.SHA256Managed
$encodeObject = new-object System.Text.ASCIIEncoding

$var = "dbx"
$efi_guid = "`{d719b2cb-3d3a-4596-a3bc-dad00e67656f`}"
$time = "2011-05-21T13:31:00z"
$signedBy = $d + "\..\TestCerts\PK\PK.pfx"
$password = ""

###############################################################################
# Everything else is calculated
###############################################################################

# Always append for dbx
$append = $true
$appendstring = "append_" 
$attribute = "0x67"

[string[]] $hashes = @()
$appendstring
for ($i=0; $i -lt 1; $i++)
{
   $SigList = $certname + $i + "_SigList.bin"
   $serialization = $certname + $i + "_SigList_Serialization_for_" + $var + ".bin"
   $signature = $serialization + ".p7"
   $example = "Example_SetVariable_Data-" + $certname + $i + "_" + $appendstring + $var + ".bin" 

   $hashString = ([System.BitConverter]::ToString($hashObject.ComputeHash($i))).Replace("-","")
   $hashes = $hashes + $hashString;
   $i
   $i.GetType()
   $hashes[$i]
   
   
   Format-SecureBootUEFI -Name $var -SignatureOwner $sigowner -Hash $hashes -Algorithm sha256 -ContentFilePath $siglist -SignableFilePath $serialization -Time $time -AppendWrite:$append 
   
signtool.exe sign /fd sha256 /p7 .\ /p7co 1.2.840.113549.1.7.1 /p7ce DetachedSignedData /a /u "1.3.6.1.4.1.311.79.2.1" /f $signedBy $password $serialization
   
   Set-SecureBootUEFI -Time $time -ContentFilePath $siglist -OutputFilePath $example -Name $var -AppendWrite:$append
   
   if (Test-Path ($toolspath + "\authvar.exe")) {
       Trace-Command NativeCommandParameterBinder { authvar.exe $var $efi_guid $attribute $example $siglist } -PsHost
   }
}
