rem @echo off
::
:: INSTALLERS   :https://download-installer.cdn.mozilla.net/pub/firefox/nightly/latest-mozilla-aurora/
:: LANGUAGES    :https://www.mozilla.org/en-US/firefox/developer/all/
:: AUTHOR       :Viktor Szépe <viktor@szepe.net>
:: DOCS         :https://developer.mozilla.org/en-US/docs/Mozilla/Command_Line_Options
:: DEPENDS      :7za.exe from 7z*-extra.7z in http://sourceforge.net/projects/sevenzip/files/7-Zip/

set HOME_URL="https://www.otpbank.hu/portal/hu/OTPdirekt/Belepes"
set SETUP_URL="https://download.mozilla.org/?product=firefox-aurora-latest-ssl&os=win64&lang=en-US"

:: Make sure we are in ff-dev\
cd /D %~dp0

:: Download English(US) installer
title Checking/downloading installer ...
if NOT EXIST .\firefox-*.exe wget -nv %SETUP_URL%
7za l -y .\firefox-*.exe > nul || ( del /Q .\firefox-*.exe & wget -nv %SETUP_URL% )

:: Show the current directory
title %CD%

:: Unpack installer - Don't use ".\core\"
7za x -y .\firefox-*.exe "core\"
set PROFILEDIR=".\data"
mkdir %PROFILEDIR%

:: Permanent files
if EXIST .\user.js copy /Y .\user.js %PROFILEDIR%\
if EXIST .\cert_override.txt copy /Y .\cert_override.txt %PROFILEDIR%\
if EXIST .\cert8.db copy /Y .\cert8.db %PROFILEDIR%\

:: Start Firefox
start /WAIT .\core\firefox.exe -safe-mode -no-remote -profile %PROFILEDIR% %HOME_URL%

:: Remove Firefox
rmdir /S /Q %PROFILEDIR%
rmdir /S /Q .\core\

exit
