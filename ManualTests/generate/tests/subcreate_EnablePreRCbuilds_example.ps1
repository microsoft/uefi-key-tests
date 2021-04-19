Import-Module secureboot
$d = (pwd).Path
$toolspath += $d + "\..\..\..\tools"
$env:path = $env:path + ";" + $toolspath

###############################################################################
# db
# - Microsoft Windows PCA 2010 - DO NOT SHIP 
###############################################################################

$var = "db"
$efi_guid = "`{d719b2cb-3d3a-4596-a3bc-dad00e67656f`}"

$name = "EnablePreRCbuilds_DoNotShip_db"
$sigowner = "77fa9abd-0359-4d32-bd60-28f4e78f784b" #MSFT SigOwner GUID

$certpath = , ($d + "\..\..\certs\test\db_MSFTpreReleaseCandidateWindowsSigningCA.cer")

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

