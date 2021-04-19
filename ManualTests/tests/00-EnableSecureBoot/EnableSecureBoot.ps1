# Prior to script execution, run "Set-ExecutionPolicy Bypass -Force"

Import-Module secureboot

Write-Host "Setting self-signed Test PK..."

Set-SecureBootUEFI -Time 2011-05-21T13:30:00Z -ContentFilePath PK_SigList.bin -SignedFilePath PK_SigList_Serialization_for_PK.bin.p7 -Name PK

Write-Host "Setting PK-signed Fabrikam KEK..."

Set-SecureBootUEFI -Time 2011-05-21T13:30:00Z  -ContentFilePath Fabrikam_Test_KEK_CA_SigList.bin -SignedFilePath Fabrikam_Test_KEK_CA_SigList_Serialization_for_KEK.bin.p7 -Name KEK

Write-Host "Setting db to Microsoft Production & Test 2010 certificates..."

Set-SecureBootUEFI -Time 2011-05-21T13:30:00Z  -ContentFilePath signing_signatures_SigList.bin -SignedFilePath signing_signatures_SigList_Serialization_for_db.bin.p7 -Name db

Write-Host "`n... operation complete.  `nSetupMode should now be 0 and SecureBoot should also be 0. Reboot and verify that Windows is correctly authenticated, and that SecureBoot changes to 1."
