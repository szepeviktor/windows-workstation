@echo OFF
:: https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/tools/NSS_Tools_certutil
:: https://github.com/christian-korneck/firefox_add-certs/releases

rem :: Old method
rem 7za x -y .\firefox-*.exe "core\"
rem start /WAIT core\firefox.exe -no-remote -profile empty-certdbs\
rem :: Quit Firefox!

:: Start with an empty db
mkdir empty-certdbs
bin\certutil.exe -d empty-certdbs\ -N --empty-password

:: Add an existing certificate
:: echo | openssl s_client -connect www.otpbankdirekt.hu:443 | openssl x509 -outform PEM -out www.otpbankdirekt.hu.pem
wget -nv -O szepenet.pem http://ca.szepe.net/pem
bin\certutil.exe -d empty-certdbs\ -A -i szepenet.pem -n szepenet -t "C,,"

:: List all the certificates
bin\certutil.exe -d empty-certdbs\ -L

:: Rename db files
copy /Y empty-certdbs\cert8.db szepenet-cert8.db
copy /Y empty-certdbs\key3.db szepenet-key3.db
copy /Y empty-certdbs\secmod.db szepenet-secmod.db
rmdir /Q /S empty-certdbs\

pause
