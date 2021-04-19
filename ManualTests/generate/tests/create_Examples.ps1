$targetPath = (pwd).Path + "\..\.."
$targetTestPath = $targetPath + "\tests"
$targetExamplePath = $targetPath + "\examples"
mkdir -Force $targetTestPath
mkdir -Force $targetExamplePath

.\subcreate_set_PK_example.ps1
.\subcreate_set_KEK_example.ps1
.\subcreate_set_db_example.ps1
$filelist = (
    "PK_SigList.bin",
    "PK_SigList_Serialization_for_PK.bin",
    "PK_SigList_Serialization_for_PK.bin.p7",
    "Example_SetVariable_Data-PK_set_PK.bin",
    "Fabrikam_Test_KEK_CA_SigList.bin",
    "Fabrikam_Test_KEK_CA_SigList_Serialization_for_KEK.bin",
    "Fabrikam_Test_KEK_CA_SigList_Serialization_for_KEK.bin.p7",
    "Example_SetVariable_Data-Fabrikam_Test_KEK_CA_set_KEK.bin",
    "signing_signatures_SigList.bin",
    "signing_signatures_SigList_Serialization_for_db.bin",
    "signing_signatures_SigList_Serialization_for_db.bin.p7",
    "Example_SetVariable_Data-signing_signatures_set_db.bin"
    )
mkdir $targetTestPath\00-EnableSecureBoot -Force
copy -force -path $filelist -Destination $targetTestPath\00-EnableSecureBoot


.\subcreate_signed_hashes_example.ps1
.\subcreate_signed_lostCA_example.ps1
.\subcreate_signed_lostcertificate_example.ps1
$filelist = (
    "LostCA_SigList.bin",
    "LostCA_SigList_Serialization_for_db.bin",
    "LostCA_SigList_Serialization_for_db.bin.p7",
    "Example_SetVariable_Data-LostCA_append_db.bin"
    )
mkdir $targetTestPath\01-AllowNewCertificate -Force
copy -force -path $filelist -Destination $targetTestPath\01-AllowNewCertificate

$filelist = (
    "pressAnyKey2_hashes_SigList.bin",
    "pressAnyKey2_hashes_SigList_Serialization_for_dbx.bin",
    "pressAnyKey2_hashes_SigList_Serialization_for_dbx.bin.p7",
    "Example_SetVariable_Data-pressAnyKey2_hashes_append_dbx.bin"
    )
mkdir $targetTestPath\02-RevokeHashes -Force
copy -force -path $filelist -Destination ($targetTestPath+"\02-RevokeHashes")

$filelist = (
    "LostCertificate_SigList.bin",
    "LostCertificate_SigList_Serialization_for_dbx.bin",
    "LostCertificate_SigList_Serialization_for_dbx.bin.p7",
    "Example_SetVariable_Data-LostCertificate_append_dbx.bin"
    )
mkdir ($targetTestPath+"\03-RevokeCertificate") -Force
copy -force -path $filelist -Destination ($targetTestPath+"\03-RevokeCertificate")

.\subcreate_outofbox_example.ps1
$filelist = (
    "OutOfBox_KEK_SigList.bin",
    "OutOfBox_KEK_SigList_Serialization_for_KEK.bin",
    "OutOfBox_KEK_SigList_Serialization_for_KEK.bin.p7",
    "Example_SetVariable_Data-OutOfBox_KEK_append_KEK.bin",
    "OutOfBox_Windows_db_SigList.bin",
    "OutOfBox_Windows_db_SigList_Serialization_for_db.bin",
    "OutOfBox_Windows_db_SigList_Serialization_for_db.bin.p7",
    "Example_SetVariable_Data-OutOfBox_Windows_db_append_db.bin",
    "OutOfBox_3rdPartyUEFI_db_SigList.bin",
    "OutOfBox_3rdPartyUEFI_db_SigList_Serialization_for_db.bin",
    "OutOfBox_3rdPartyUEFI_db_SigList_Serialization_for_db.bin.p7",
    "Example_SetVariable_Data-OutOfBox_3rdPartyUEFI_db_append_db.bin"
    )
mkdir ($targetExamplePath+"\OutOfBox") -Force
copy -force -path $filelist -Destination ($targetExamplePath+"\OutOfBox")

.\subcreate_EnablePreRCbuilds_example.ps1
$filelist = (
    "EnablePreRCbuilds_DoNotShip_db_SigList.bin",
    "EnablePreRCbuilds_DoNotShip_db_SigList_Serialization_for_db.bin",
    "EnablePreRCbuilds_DoNotShip_db_SigList_Serialization_for_db.bin.p7",
    "Example_SetVariable_Data-EnablePreRCbuilds_DoNotShip_db_append_db.bin"
    )
mkdir ($targetExamplePath+"\EnablePreRCbuilds") -Force
copy -force -path $filelist -Destination ($targetExamplePath+"\EnablePreRCbuilds")


#Cleanup current directory
ri *.p7
ri *.bin
