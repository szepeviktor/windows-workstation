rem @echo off
::
:: INSTALLERS   :https://download-installer.cdn.mozilla.net/pub/firefox/nightly/latest-mozilla-aurora/
:: LANGUAGES    :https://www.mozilla.org/en-US/firefox/developer/all/
:: AUTHOR       :Viktor Szépe <viktor@szepe.net>
:: DOCS         :https://developer.mozilla.org/en-US/docs/Mozilla/Command_Line_Options
:: DEPENDS      :7za.exe from 7z*-extra.7z in http://sourceforge.net/projects/sevenzip/files/7-Zip/
:: DEPENDS      :http://memory.dataram.com/products-and-services/software/ramdisk

set RAMDISK="F:\ff-dev\"
set HOME_URL="https://szepe.net/"
set SETUP_URL="https://download.mozilla.org/?product=firefox-aurora-latest-ssl&os=win64&lang=en-US"

:: Make sure we are in ff-dev\
cd /D %~dp0

:: Download English(US) installer
title Checking/downloading installer ...
if NOT EXIST .\firefox-*.exe wget -nv %SETUP_URL%
7za l -y .\firefox-*.exe > nul || ( del /Q .\firefox-*.exe & wget -nv %SETUP_URL% )

:: Set root path
title Detecting RAMDISK ...
set ORIGINALDIR="%CD%"
if EXIST %RAMDISK:~1,3% (
    xcopy /Y . %RAMDISK%
    cd /D %RAMDISK%
)

:: Show the current directory
title %CD%

:: Unpack installer - Don't use ".\core\"
7za x -y .\firefox-*.exe "core\"
set PROFILEDIR=".\data"
mkdir %PROFILEDIR%

:: Permanent files
if EXIST .\user.js copy /Y .\user.js %PROFILEDIR%\
rem if EXIST .\cert_override.txt copy /Y .\cert_override.txt %PROFILEDIR%\
rem if EXIST .\cert8.db copy /Y .\cert8.db %PROFILEDIR%\
if EXIST .\places.sqlite copy /Y .\places.sqlite %PROFILEDIR%\

:: Adblock Plus extension
set EXT_ABP="{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}.xpi"
set EXT_ABP_URL="https://addons.mozilla.org/firefox/downloads/latest/1865/addon-1865-latest.xpi"
if NOT EXIST .\%EXT_ABP% (
    wget -nv -O .\%EXT_ABP% %EXT_ABP_URL%
)
if EXIST .\%EXT_ABP% copy /Y .\%EXT_ABP% .\core\browser\extensions\

:: Start Firefox
rem start /WAIT .\core\firefox.exe -safe-mode -no-remote -profile %PROFILEDIR% "https://www.otpbank.hu/portal/hu/OTPdirekt/Belepes"
start /WAIT .\core\firefox.exe -no-remote -profile %PROFILEDIR% %HOME_URL%

:: Keep bookmarks
move /Y %PROFILEDIR%\places.sqlite %ORIGINALDIR%

:: Remove Firefox
rem rmdir /S /Q %PROFILEDIR%\cache2
rmdir /S /Q %PROFILEDIR%
rmdir /S /Q .\core\

exit


:: Bookmarks
I'm feeling luck - kw:1 - https://www.google.com/search?btnI=1&q=%s

:: ABP filters
http://preview.tinyurl.com/adblockhu-subscribe
https://github.com/szepeviktor/lean-filter/blob/master/README.md
