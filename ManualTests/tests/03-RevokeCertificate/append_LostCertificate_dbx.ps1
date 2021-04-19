# Prior to script execution, run "Set-ExecutionPolicy Bypass -Force"

$ContentFilePath = "LostCertificate_SigList.bin" 
$SignedFilePath = "LostCertificate_SigList_Serialization_for_dbx.bin.p7" 
$time = "2011-05-21T13:32:00z"

Write-Host "`nPrecondition:" 
Write-Host "UEFI Secure Boot should be enabled with the certificates in this package properly enrolled."
Write-Host "Lost_CA.cer should already be enrolled in `"db`"."

Write-Host "`nAppending Lost_CA.cer to the FORBIDDEN signature database `"dbx`" using EFI_VARIABLE_AUTHENTICATION_2 signed by the MSFT Test KEK..."


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
$appendSize = (Get-Item $ContentFilePath).Length
"Initial dbx size " + $initialDbxSize
"New dbx size " + $newDbxSize
"Expected dbx growth " + $appendSize
"Measured dbx growth " + $dbxGrowth

if ($dbxGrowth -eq 0)
{
    Write-Host -foreground "red" "`n!!!!! FAILED !!!!! dbx database should grow when new signatures are appended."
    Write-Host "NOTE: if you are re-running this test case, this failure is expected and acceptable."
}
elseif ($dbxGrowth -lt ($appendSize))
{
    Write-Host -foreground "red" "`n!!!!! FAILED !!!!! dbx database did not grow enough to contain the new signatures."
}
elseif ($dbxGrowth -gt ($appendSize))
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

Write-Host "`n... operation complete.  `nReboot and verify that both `"pressAnyKey.efi`" & `"pressAnyKey2.efi`" fail to authenticate and execution is blocked."
