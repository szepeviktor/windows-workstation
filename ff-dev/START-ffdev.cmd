@echo off
::
:: Disposable browser.
::
:: INSTALLERS   :https://download-installer.cdn.mozilla.net/pub/firefox/nightly/latest-mozilla-aurora/
:: LANGUAGES    :https://www.mozilla.org/en-US/firefox/developer/all/
:: AUTHOR       :Viktor Szépe <viktor@szepe.net>
:: DOCS         :https://developer.mozilla.org/en-US/docs/Mozilla/Command_Line_Options
:: DEPENDS      :7za.exe from 7z*-extra.7z in http://sourceforge.net/projects/sevenzip/files/7-Zip/
:: DEPENDS      :http://memory.dataram.com/products-and-services/software/ramdisk

:: @TODO Rewrite in AHK
:: Visualize connections: https://addons.mozilla.org/en-US/firefox/addon/lightbeam/

:: No trailing backslash in RAMDISK
set RAMDISK="F:\ff-dev"
set HOME_URL="https://szepe.net/"
set SETUP_URL="https://download.mozilla.org/?product=firefox-aurora-latest-ssl&os=win64&lang=en-US"
rem set SETUP_URL="https://download.mozilla.org/?product=firefox-45.0-SSL&os=win64&lang=en-US"
set SETUP_WILDCARD=firefox-*.exe
set CORE_DIR=core
set BINARY=firefox.exe

:: Make sure we are in ff-dev\
cd /D %~dp0
call :Exit_if_running "%CD%"

:: Download US English installer
title Checking/downloading installer ...
if NOT EXIST .\%SETUP_WILDCARD% wget -nv %SETUP_URL%
:: Check installer integrity
7za l -y .\%SETUP_WILDCARD% > NUL || (
    del /Q .\%SETUP_WILDCARD%
    wget -nv %SETUP_URL%
    7za l -y .\%SETUP_WILDCARD% > NUL || exit 2
)

:: Set root path
title Detecting RAMDISK ...
set ORIGINALDIR="%CD%"
call :Exit_if_running %RAMDISK%
if EXIST %RAMDISK:~1,3% (
    xcopy /Y . %RAMDISK%\ > NUL
    cd /D %RAMDISK%
)

:: Show the current directory
title %CD%

:: Unpack installer - Don't use ".\%CORE_DIR%\"
7za x -y .\%SETUP_WILDCARD% "%CORE_DIR%\"
:: Prevent pending updates
rmdir /Q /S %LOCALAPPDATA%\Mozilla\Firefox\firefox\updates\ > NUL 2>&1
set PROFILEDIR=".\data"
mkdir %PROFILEDIR%

:: Permanent files
if EXIST .\user.js copy /Y .\user.js %PROFILEDIR%\ > NUL
if EXIST .\places.sqlite copy /Y .\places.sqlite %PROFILEDIR%\ > NUL

:: szepenet CA
if EXIST .\szepenet-cert8.db if EXIST .\szepenet-key3.db if EXIST .\szepenet-secmod.db (
    copy /Y .\szepenet-cert8.db %PROFILEDIR%\cert8.db > NUL
    copy /Y .\szepenet-key3.db %PROFILEDIR%\key3.db > NUL
    copy /Y .\szepenet-secmod.db %PROFILEDIR%\secmod.db > NUL
)

:: Flash plugin
rem mkdir "%CORE_DIR%\plugins\"
rem copy "%SystemRoot%\SysWOW64\Macromed\Flash\NPSWF32_"*.dll "%CORE_DIR%\plugins\"

:: Search engines
if EXIST .\search-google1.xml (
    mkdir %PROFILEDIR%\searchplugins
    copy /Y .\search-google1.xml %PROFILEDIR%\searchplugins\ > NUL
)

:: Extension version check (XML response)
:: https://wiki.mozilla.org/AMO:Users/Checking_For_Updates https://addons.mozilla.org/update/VersionCheck.php?reqVersion=1&id=%EXT_ID%&version=%EXT_VER%&maxAppVersion=43.0&status=userEnabled&appID={ec8030f7-c20a-464f-9b0e-13a3a9e97384}&appVersion=46.0.1&appOS=WINNT&appABI=x86_64-msvc&locale=en-US&currentAppVersion=46.0.1&updateType=97&compatMode=normal

:: uBlock Origin extension
rem DELETE FROM settings WHERE name != "advancedUserEnabled" and name != "webrtcIPAddressHidden";
set EXT_UBO=".\uBlock0@raymondhill.net.xpi"
set EXT_UBO_URL="https://addons.mozilla.org/firefox/downloads/latest/607454/addon-607454-latest.xpi"
if NOT EXIST %EXT_UBO% (
    wget -nv -O %EXT_UBO% %EXT_UBO_URL%
)
if EXIST %EXT_UBO% copy /Y %EXT_UBO% .\%CORE_DIR%\browser\extensions\ > NUL

:: dotjs extension
set EXT_DOTJS=".\jid0-HC7vB1GcMVr7IBB5B5ADUjTJB3U@jetpack.xpi"
set EXT_DOTJS_URL="https://addons.mozilla.org/firefox/downloads/latest/285518/platform:5/addon-285518-latest.xpi"
if NOT EXIST %EXT_DOTJS% (
    wget -nv -O %EXT_DOTJS% %EXT_DOTJS_URL%
)
if EXIST %EXT_DOTJS% copy /Y %EXT_DOTJS% .\%CORE_DIR%\browser\extensions\ > NUL

:: Always Right extension
set EXT_AWR=".\jid0-SzimoL45Ib8OddgoUBG0buQmjec@jetpack.xpi"
set EXT_AWR_URL="https://addons.mozilla.org/firefox/downloads/latest/273653/addon-273653-latest.xpi"
if NOT EXIST %EXT_AWR% (
    wget -nv -O %EXT_AWR% %EXT_AWR_URL%
)
if EXIST %EXT_AWR% copy /Y %EXT_AWR% .\%CORE_DIR%\browser\extensions\ > NUL

:: Start Firefox
title %CD% - Started
start /WAIT .\%CORE_DIR%\%BINARY% -no-remote -profile %PROFILEDIR% %HOME_URL%

:: Persistent bookmarks
move /Y %PROFILEDIR%\places.sqlite %ORIGINALDIR%

:: Remove Firefox
rmdir /S /Q %PROFILEDIR%
rmdir /S /Q .\%CORE_DIR%\

exit /B 0

:Exit_if_running
wmic process where "name='%BINARY%'" get ExecutablePath /format:list 2> NUL | find /I "%~1\%CORE_DIR%\%BINARY%" > NUL
if NOT ERRORLEVEL 1 exit 1
goto :EOF

:: Bookmarks
I'm feeling luck - kw:1 - https://encrypted.google.com/search?btnI=1&pws=0&q=%s

:: Google consent cookie
document.cookie = "CONSENT=YES+HU.hu+V2;domain=.google.hu;expires=Sun, 10-Jan-2038 07:59:59 GMT;path=/";

:: ABP filters
http://preview.tinyurl.com/adblockhu-subscribe
http://preview.tinyurl.com/adblock-leanfilter
