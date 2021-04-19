# Prior to script execution, run "Set-ExecutionPolicy Bypass -Force"

Import-Module secureboot


Write-Host "KEK: Appending Microsoft Production KEK CA"
Set-SecureBootUEFI -Time 2011-05-21T13:30:00Z -ContentFilePath OutOfBox_KEK_SigList.bin -Name KEK -AppendWrite
# NOTE: OutOfBox_KEK_SigList.bin contains KEK_MSFTproductionKekCA.cer


Write-Host "db: Appending Microsoft Windows 2011 CA certificate to enable Windows to boot"
Set-SecureBootUEFI -Time 2011-05-21T13:30:00Z  -ContentFilePath OutOfBox_Windows_db_SigList.bin -Name db -AppendWrite
# NOTE: OutOfBox_Windows_db_SigList.bin contains certs\db_MSFTproductionWindowsSigningCA2011.cer


# OPTIONAL: Uncomment the following 2 lines to enable 3rd-party UEFI drivers such as video (GOP), network (UNDI), and 3rd-party UEFI applications
#Write-Host "db: Appending the Microsoft 3rd-Party UEFI signing CA"
#Set-SecureBootUEFI -Time 2011-05-21T13:30:00Z  -ContentFilePath OutOfBox_3rdPartyUEFI_db_SigList.bin  -Name db -AppendWrite
# NOTE: OutOfBox_3rdPartyUEFI_db_SigList.bin contains certs\db_MSFTproductionUEFIsigningCA.cer


# Appending placeholder dbx to pin attributes 
Write-Host "dbx: Appending the SHA-256 hash of 0x00"
Set-SecureBootUEFI -Time 2011-05-21T13:31:00z  -ContentFilePath hash0_SigList.bin  -Name dbx -AppendWrite


# !!! TODO: Replace with your PK and uncomment the following
# Write-Host "PK: !!! WARNING !!! Setting to TEST Fabrikam PK Certificate !!!"
# Set-SecureBootUEFI -Time 2011-05-21T13:30:00Z  -ContentFilePath OEM_PK_SigList.bin  -Name PK
# NOTE: OEM_PK_SigList.bin contains certs\test\PK.cer
