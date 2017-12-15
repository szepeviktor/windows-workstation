@echo OFF
::
:: Create an empty certificate database with provided certificates.
::
:: AUTHOR       :Viktor Szépe <viktor@szepe.net>
:: DOCS         :https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/tools/NSS_Tools_certutil
:: DEPENDS      :https://github.com/christian-korneck/firefox_add-certs/releases

:: Start with an empty db
mkdir certdbs
bin\certutil.exe -d certdbs\ -N --empty-password

:: Download certificates
:: type nul | openssl s_client -connect www.otpbank.hu:443 | openssl x509 -outform PEM -out www.otpbank.hu.crt
:: type nul | openssl s_client -connect www.otpbankdirekt.hu:443 | openssl x509 -outform PEM -out www.otpbankdirekt.hu.crt
:: type nul | openssl s_client -connect cdnjs.cloudflare.com:443 | openssl x509 -outform PEM -out ssl412106.cloudflaressl.com.crt
:: type nul | openssl s_client -connect cap.attempts.securecode.com:443 | openssl x509 -outform PEM -out cap.attempts.securecode.com.crt

:: Add certificates
bin\certutil.exe -d certdbs\ -A -i www.otpbank.hu.crt -n www.otpbank.hu -t "C,,"
bin\certutil.exe -d certdbs\ -A -i www.otpbankdirekt.hu.crt -n www.otpbankdirekt.hu -t "C,,"
bin\certutil.exe -d certdbs\ -A -i ssl412106.cloudflaressl.com.crt -n ssl412106.cloudflaressl.com -t "C,,"
bin\certutil.exe -d certdbs\ -A -i cap.attempts.securecode.com.crt -n cap.attempts.securecode.com -t "C,,"

:: List all the certificates
bin\certutil.exe -d certdbs\ -L

pause
