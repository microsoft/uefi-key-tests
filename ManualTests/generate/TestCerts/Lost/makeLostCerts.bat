MakeCert.exe -r -cy authority -len 4096 -m 240 -a sha384 -sv Lost_Root.pvk -pe -ss my -n "CN=DO NOT TRUST - Lost Certificate Root sha384" Lost_Root.cer
pvk2pfx -pvk Lost_Root.pvk -spc Lost_Root.cer -pfx Lost_Root.pfx

MakeCert.exe -cy authority -len 4096 -m 180 -a sha384 -ic Lost_Root.cer -iv Lost_Root.pvk -sv Lost_CA.pvk -pe -ss my -n "CN=DO NOT SHIP - Lost Certificate CA rsa4096-sha384" Lost_CA.cer
pvk2pfx -pvk Lost_CA.pvk -spc Lost_CA.cer -pfx Lost_CA.pfx

MakeCert.exe -len 3072 -m 24 -a sha384 -ic Lost_CA.cer -iv Lost_CA.pvk -sv Lost.pvk -pe -ss my -n "CN=DO NOT SHIP - Lost Certificate rsa3072-sha384" Lost.cer
pvk2pfx -pvk Lost.pvk -spc Lost.cer -pfx Lost.pfx

copy Lost_CA.cer ..\..\..\certs\test
