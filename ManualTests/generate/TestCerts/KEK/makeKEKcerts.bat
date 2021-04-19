MakeCert.exe -r -cy authority -len 4096 -m 240 -a sha384 -sv Fabrikam_Test_KEK_Root.pvk -pe -ss my -n "CN=DO NOT TRUST - Fabrikam Test KEK Root sha384" Fabrikam_Test_KEK_Root.cer
pvk2pfx -pvk Fabrikam_Test_KEK_Root.pvk -spc Fabrikam_Test_KEK_Root.cer -pfx Fabrikam_Test_KEK_Root.pfx

MakeCert.exe -cy authority -len 4096 -m 180 -a sha384 -ic Fabrikam_Test_KEK_Root.cer -iv Fabrikam_Test_KEK_Root.pvk -sv Fabrikam_Test_KEK_CA.pvk -pe -ss my -n "CN=DO NOT SHIP - Fabrikam Test KEK CA rsa4096-sha384" Fabrikam_Test_KEK_CA.cer
pvk2pfx -pvk Fabrikam_Test_KEK_CA.pvk -spc Fabrikam_Test_KEK_CA.cer -pfx Fabrikam_Test_KEK_CA.pfx

MakeCert.exe -len 3072 -m 24 -a sha384 -ic Fabrikam_Test_KEK_CA.cer -iv Fabrikam_Test_KEK_CA.pvk -sv Fabrikam_Test_KEK.pvk -pe -ss my -n "CN=DO NOT SHIP - Fabrikam Test KEK rsa3072-sha384" Fabrikam_Test_KEK.cer
pvk2pfx -pvk Fabrikam_Test_KEK.pvk -spc Fabrikam_Test_KEK.cer -pfx Fabrikam_Test_KEK.pfx

copy Fabrikam_Test_KEK_CA.cer ..\..\..\certs\test\KEK_Fabrikam_Test_KEK_CA.cer
