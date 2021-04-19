rem Set your clock back if Lost.pfx has expired
signtool sign /fd sha256 /a /f Lost.pfx ..\..\..\apps\x64\p*.efi ..\..\..\apps\arm\p*.efi ..\..\..\apps\x86\p*.efi
