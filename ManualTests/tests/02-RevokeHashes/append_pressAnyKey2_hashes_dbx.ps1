# Prior to script execution, run "Set-ExecutionPolicy Bypass -Force"

$ContentFilePath = "pressAnyKey2_hashes_SigList.bin"
$SignedFilePath  = "pressAnyKey2_hashes_SigList_Serialization_for_dbx.bin.p7"
$time = "2011-05-21T13:31:00z"

Write-Host "`nPrecondition:" 
Write-Host "UEFI Secure Boot should be enabled with the certificates in this package properly enrolled."
Write-Host "Lost_CA.cer should already be enrolled in `"db`"."

Write-Host "`nAppending the SHA-256 hashes of `"amd64\pressAnyKey2.efi`", `"x86\pressAnyKey2.efi`", and `"arm\pressAnyKey2.efi`" to the forbidden signature database `"dbx`" using EFI_VARIABLE_AUTHENTICATION_2 signed by the MSFT Test KEK..."


try 
{
    $initialDbxSize = (Get-SecureBootUEFI dbx).Bytes.Length
}
catch
{
    #for Servicing test, dbx may not be created yet...
    $initialDbxSize = 0
}


try 
{
    Set-SecureBootUEFI -Name dbx -Time $time -ContentFilePath $ContentFilePath -SignedFilePath $SignedFilePath -AppendWrite
    $newDbxSize = (Get-SecureBootUEFI dbx).Bytes.Length
}
catch
{
    Write-Host -foreground "red" "`n!!!!! FAILED !!!!! Attempt to access dbx failed" 
    Write-Host "DETAILS:"
    $_
    Exit
}

$dbxGrowth = $newDbxSize - $initialDbxSize
$appendSizeMax = (Get-Item $ContentFilePath).Length
$appendSizeMin = $appendSizeMax - 28
"Initial dbx size " + $initialDbxSize
"New dbx size " + $newDbxSize
"Expected dbx growth " + $appendSizeMin + " to " + $appendSizeMax
"Measured dbx growth " + $dbxGrowth

if ($dbxGrowth -eq 0)
{
    Write-Host -foreground "red" "`n!!!!! FAILED !!!!! dbx database should grow when new signatures are appended."
    Write-Host "NOTE: if you are re-running this test case, this failure is expected and acceptable."
}
elseif ($dbxGrowth -lt ($appendSizeMin))
{
    Write-Host -foreground "red" "`n!!!!! FAILED !!!!! dbx database did not grow enough to contain the new signatures."
}
elseif ($dbxGrowth -gt ($appendSizeMax))
{
    Write-Host -foreground "red" "`n!!!!! FAILED !!!!! dbx grew too much.  Append operations should strip redundant signatures."
    Write-Host "Reference the UEFI Specification: `"For variables with the GUID EFI_IMAGE_SECURITY_DATABASE_GUID (i.e. where the data buffer is formatted as EFI_SIGNATURE_LIST), the driver shall not perform an append of EFI_SIGNATURE_DATA values that are already part of the existing variable value.`"" 
}
else
{
    Write-Host -foreground "Green" "`n***SUCCESS*** dbx grew an acceptable amount"
}


#####################################################################
Write-Host "Attempting a second append with the identical data.  The database should not grow."
try 
{
    $initialDbxSize = (Get-SecureBootUEFI dbx).Bytes.Length
    Set-SecureBootUEFI -Name dbx -Time $time -ContentFilePath $ContentFilePath -SignedFilePath $SignedFilePath -AppendWrite
    $newDbxSize = (Get-SecureBootUEFI dbx).Bytes.Length
}
catch
{
    Write-Host -foreground "red" "`n!!!!! FAILED !!!!! Attempt to access dbx failed" 
    Write-Host "DETAILS:"
    $_
    Exit
}

$dbxGrowth = $newDbxSize - $initialDbxSize
if ($dbxGrowth -ne 0)
{
    Write-Host -foreground "red" "`n!!!!! FAILED !!!!! dbx should NOT grow when we append an identical signature"
}

Write-Host "`n... operation complete.  `nReboot and verify that `"<platform>\pressAnyKey2.efi`" fails to authenticate, but `"<platform>\pressAnyKey.efi`" should still authenticate and execute successfully."
