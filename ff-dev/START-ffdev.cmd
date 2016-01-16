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
if EXIST .\places.sqlite copy /Y .\places.sqlite %PROFILEDIR%\

:: szepenet CA
if EXIST .\szepenet-cert8.db if EXIST .\szepenet-key3.db if EXIST .\szepenet-secmod.db (
    copy /Y .\szepenet-cert8.db %PROFILEDIR%\cert8.db
    copy /Y .\szepenet-key3.db %PROFILEDIR%\key3.db
    copy /Y .\szepenet-secmod.db %PROFILEDIR%\secmod.db
)

:: Only OTP Bank certificates
rem if EXIST .\all-but-otp-cert_override.txt if EXIST .\all-but-otp-cert8.db if EXIST .\all-but-otp-key3.db if EXIST .\all-but-otp-secmod.db (
rem     copy /Y .\all-but-otp-cert_override.txt %PROFILEDIR%\cert_override.txt
rem     copy /Y .\all-but-otp-cert8.db %PROFILEDIR%\cert8.db
rem     copy /Y .\all-but-otp-key3.db %PROFILEDIR%\key3.db
rem     copy /Y .\all-but-otp-secmod.db %PROFILEDIR%\secmod.db
rem )

:: uBlock Origin extension
set EXT_UBO=".\uBlock0@raymondhill.net.xpi"
set EXT_UBO_URL="https://addons.mozilla.org/firefox/downloads/latest/607454/addon-607454-latest.xpi"
if NOT EXIST %EXT_UBO% (
    wget -nv -O %EXT_UBO% %EXT_UBO_URL%
)
if EXIST %EXT_UBO% copy /Y %EXT_UBO% .\core\browser\extensions\

:: Always Right extension
set EXT_AWR=".\jid0-SzimoL45Ib8OddgoUBG0buQmjec@jetpack.xpi"
set EXT_AWR_URL="https://addons.mozilla.org/firefox/downloads/file/304228/always_right-1.4-fx.xpi"
if NOT EXIST %EXT_AWR% (
    wget -nv -O %EXT_AWR% %EXT_AWR_URL%
)
if EXIST %EXT_AWR% copy /Y %EXT_AWR% .\core\browser\extensions\

:: TR
rem set EXT_TR=".\{50ee6140-601e-11e0-80e3-0800200c9a66}.xpi"
rem set EXT_TR_URL="https://addons.mozilla.org/firefox/downloads/file/130496/tabsright-1.0-beta-4-fx.xpi"
rem if NOT EXIST %EXT_TR% (
rem     wget -nv -O %EXT_TR% %EXT_TR_URL%
rem )
rem if EXIST %EXT_TR% copy /Y %EXT_TR% .\core\browser\extensions\

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
http://preview.tinyurl.com/adblock-leanfilter
