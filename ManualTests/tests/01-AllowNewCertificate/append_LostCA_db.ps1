# Prior to script execution, run "Set-ExecutionPolicy Bypass -Force"

Import-Module secureboot

Write-Host "`nPrecondition:" 
Write-Host "UEFI Secure Boot should be enabled with the certificates in this package properly enrolled."

Write-Host "`nAppending LostCA.cer to the authorized signature database `"db`" using EFI_VARIABLE_AUTHENTICATION_2 signed by the MSFT Test KEK..."

try 
{
    $initialDbSize = (Get-SecureBootUEFI db).Bytes.Length
    Set-SecureBootUEFI -Name db -Time 2011-05-21T13:30:00z -ContentFilePath LostCA_SigList.bin -SignedFilePath LostCA_SigList_Serialization_for_db.bin.p7 -AppendWrite
    $newDbSize = (Get-SecureBootUEFI db).Bytes.Length
}
catch
{
    Write-Host -foreground "red" "`n!!!!! FAILED !!!!! Attempt to access db failed" 
    Write-Host "DETAILS:"
    $_
    Exit
}

$dbGrowth = $newDbSize - $initialDbSize
if ($dbGrowth -eq 0)
{
    Write-Host -foreground "red" "`n!!!!! FAILED !!!!! db database should grow the first time we append a new signature."
    Write-Host "NOTE: if you are re-running this test case, this failure is expected and acceptable."
}


#append the same signature and verify that the variable does not grow
try 
{
    $initialDbSize = (Get-SecureBootUEFI db).Bytes.Length
    Set-SecureBootUEFI -Name db -Time 2011-05-21T13:30:00z -ContentFilePath LostCA_SigList.bin -SignedFilePath LostCA_SigList_Serialization_for_db.bin.p7 -AppendWrite
    $newDbSize = (Get-SecureBootUEFI db).Bytes.Length
}
catch
{
    Write-Host -foreground "red" "`n!!!!! FAILED !!!!! Attempt to access db failed" 
    Write-Host "DETAILS:"
    $_
    Exit
}

$dbGrowth = $newDbSize - $initialDbSize
if ($dbGrowth -ne 0)
{
    Write-Host -foreground "red" "`n!!!!! FAILED !!!!! db should NOT grow when we append an identical signature"
}

Write-Host "`n... operation complete.  `nReboot and verify that both `"pressAnyKey.efi`" & `"pressAnyKey2.efi`" successfully authenticate & execute."
