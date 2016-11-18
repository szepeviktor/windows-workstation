@echo off
::
:: OpenSSL command line tool.
::
:: INSTALLERS   :https://indy.fulgan.com/SSL/openssl-1.0.2j-x64_86-win64.zip
:: AUTHOR       :Viktor Szépe <viktor@szepe.net>
:: DOCS         :https://www.openssl.org/docs/manmaster/apps/config.html
:: LOCATION     :C:\usr\bin\openssl.cmd

:: echo CAfile = C:/usr/bin/cacert.pem> C:\usr\openssl\openssl.cnf
set OPENSSL_CONF=C:\usr\openssl\openssl.cnf

:: From wget
set SSL_CERT_FILE=C:\usr\bin\cacert.pem

C:\usr\openssl\openssl.exe %*
