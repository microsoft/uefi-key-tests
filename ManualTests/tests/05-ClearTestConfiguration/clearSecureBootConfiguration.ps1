# Prior to script execution, run "Set-ExecutionPolicy Bypass -Force"
 
"WHCK 05-ClearTestConfiguration"

try 
{
    "`nPrecondition:" 
    "The system has been configured by the Secure Boot Manual Test." 
    "`nRestoring the system to Setup Mode by programatically deleting the PK..." 
    # NOTE: This is for test automation purposes ONLY, you should NEVER do this!
    Set-SecureBootUEFI -Name PK -Time "2011-06-06T13:30:00Z" -Content $null -SignedFilePath delete.p7
    
    # Delete "db" first to test for Tiano bug where "db" cannot be deleted  
    # in Setup Mode when KEK present.  Also tests bug where deleting "db" 
    # incorrectly returns EFI_NOT_FOUND instead of the expected EFI_SUCCESS.
    "`nDeleting db"
    Set-SecureBootUEFI -Name db -Time "2011-06-06T13:30:00Z" -Content $null
    
    # Also tests bug where deleting "KEK" incorrectly returns EFI_NOT_FOUND 
    # instead of the expected EFI_SUCCESS.
    "`nDeleting KEK"
    Set-SecureBootUEFI -Name KEK -Time "2011-06-06T13:30:00Z" -Content $null
    
    # Also tests bug where deleting "dbx" incorrectly returns EFI_NOT_FOUND 
    # instead of the expected EFI_SUCCESS.
    "`nDeleting dbx"
    Set-SecureBootUEFI -Name dbx -Time "2011-06-06T13:30:00Z" -Content $null
}
catch
{
    Write-Host -foreground "red" "`n!!!!! FAILED !!!!! Attempting to clear Secure Boot." 
    "WHCK 05-ClearTestConfiguration: FAILED!!!"
    "DETAILS:"
    $_
    Exit
}

Write-Host -foreground "Green" "`n***SUCCESS***"
