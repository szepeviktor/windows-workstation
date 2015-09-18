@echo off
::
:: INSTALLERS   :https://download-installer.cdn.mozilla.net/pub/firefox/nightly/latest-mozilla-aurora/
:: LANGUAGES    :https://www.mozilla.org/en-US/firefox/developer/all/
:: AUTHOR       :Viktor Szépe <viktor@szepe.net>

:: Set root path
:: RAMDISK http://memory.dataram.com/products-and-services/software/ramdisk
set ORIGINALDIR="%CD%"
IF EXIST F:\ (
    xcopy /Y . F:\ff-dev\
    cd /D F:\ff-dev\
)

title %CD%

:: Download English installer
IF NOT EXIST "firefox-*.exe" wget -nv "https://download.mozilla.org/?product=firefox-aurora-latest-ssl&os=win64&lang=en-US"

:: Unpack
:: Extract 7za.exe from 7z*-extra.7z in http://sourceforge.net/projects/sevenzip/files/7-Zip/
7za x -y "firefox-*.exe" core\
set PROFILEDIR=".\data"
mkdir %PROFILEDIR%

:: Permanent files
IF EXIST user.js copy /Y user.js %PROFILEDIR%\
rem IF EXIST cert_override.txt copy /Y cert_override.txt %PROFILEDIR%\
rem IF EXIST cert8.db copy /Y cert8.db %PROFILEDIR%\
IF EXIST places.sqlite copy /Y places.sqlite %PROFILEDIR%\

:: Adblock Plus extension
IF NOT EXIST "{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}.xpi" (
    wget -nv -O "{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}.xpi" "https://addons.mozilla.org/firefox/downloads/latest/1865/addon-1865-latest.xpi"
)
IF EXIST "{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}.xpi" copy /Y "{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}.xpi" core\browser\extensions\

:: Start Firefox
rem start /WAIT core\firefox.exe -safe-mode -no-remote -profile %PROFILEDIR% "https://www.otpbank.hu/portal/hu/OTPdirekt/Belepes"
start /WAIT core\firefox.exe -no-remote -profile %PROFILEDIR% "{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}.xpi" "https://szepe.net/"

:: Keep bookmarks
move /Y %PROFILEDIR%\places.sqlite %ORIGINALDIR%

:: Remove Firefox
rem rmdir /S /Q %PROFILEDIR%\cache2
rmdir /S /Q %PROFILEDIR%
rmdir /S /Q core\

exit


:: Bookmarks
I'm feeling luck kw:1
https://www.google.com/search?btnI=1&q=%s
