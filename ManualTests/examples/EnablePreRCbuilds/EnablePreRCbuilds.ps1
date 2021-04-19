# Prior to script execution, run "Set-ExecutionPolicy Bypass -Force"

Import-Module secureboot

Write-Host "Appending the production TEST certificate to enable booting of Prerelease Windows builds..."

Set-SecureBootUEFI -Time 2011-05-21T13:30:00Z -ContentFilePath EnablePreRCbuilds_DoNotShip_db_SigList.bin -SignedFilePath EnablePreRCbuilds_DoNotShip_db_SigList_Serialization_for_db.bin.p7 -Name db -AppendWrite

Write-Host "DO NOT SHIP systems with this certificate enrolled!"
