@echo OFF
::
:: Create an empty certificate database with provided certificates
::
:: https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/tools/NSS_Tools_certutil
:: https://github.com/christian-korneck/firefox_add-certs/releases

:: Start with an empty db
mkdir certdbs
bin\certutil.exe -d certdbs\ -N --empty-password

:: Add certificates
:: echo | openssl s_client -connect www.otpbank.hu:443 | openssl x509 -outform PEM -out www.otpbank.hu.pem
:: echo | openssl s_client -connect www.otpbankdirekt.hu:443 | openssl x509 -outform PEM -out www.otpbankdirekt.hu.pem
bin\certutil.exe -d certdbs\ -A -i www.otpbank.hu.pem -n www.otpbank.hu -t "C,,"
bin\certutil.exe -d certdbs\ -A -i www.otpbankdirekt.hu.pem -n www.otpbankdirekt.hu -t "C,,"

:: List all the certificates
bin\certutil.exe -d certdbs\ -L

pause
