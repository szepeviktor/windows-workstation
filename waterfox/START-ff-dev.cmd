@echo off
::
:: Disposable browser.
::
:: INSTALLERS   :https://www.waterfoxproject.org/downloads
:: AUTHOR       :Viktor Szépe <viktor@szepe.net>
:: DOCS         :https://developer.mozilla.org/en-US/docs/Mozilla/Command_Line_Options
:: DEPENDS      :7za.exe from 7z*-extra.7z in http://sourceforge.net/projects/sevenzip/files/7-Zip/
:: DEPENDS      :http://memory.dataram.com/products-and-services/software/ramdisk

:: @TODO Rewrite in AHK
:: Visualize connections: https://addons.mozilla.org/en-US/firefox/addon/lightbeam/

:: No trailing backslash in RAMDISK
set RAMDISK="F:\waterfox1"
set HOME_URL="https://szepe.net/"
:: https://www.waterfoxproject.org/update/win64/54.0.1/en-US/release/update.xml
set SETUP_URL="https://storage-waterfox.netdna-ssl.com/releases/win64/installer/Waterfox%2056.2.0%20Setup.exe"
set SETUP_WILDCARD=Waterfox*Setup.exe
set CORE_DIR=core
set BINARY=waterfox.exe
set PROFILEDIR=".\data"

:: Make sure we are in ff-dev\
cd /D %~dp0
call :Exit_if_running "%CD%"
set ORIGINALDIR="%CD%"

:: Download installer
title Checking/downloading installer ...
if NOT EXIST .\%SETUP_WILDCARD% wget -nv %SETUP_URL%

:: Check installer's integrity
7za l -y .\%SETUP_WILDCARD% > NUL || (
    del /Q .\%SETUP_WILDCARD%
    :: Redownload installer
    wget -nv %SETUP_URL%
    7za l -y .\%SETUP_WILDCARD% > NUL || exit 2
)

:: Set root path
title Detecting RAMDISK ...
call :Exit_if_running %RAMDISK%

:: Use RAM disk if available
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
del /Q .\%CORE_DIR%\updater.exe > NUL 2>&1

:: Create profile directory
mkdir %PROFILEDIR%

:: Permanent files
if EXIST .\user.js copy /Y .\user.js %PROFILEDIR%\ > NUL
if EXIST .\places.sqlite copy /Y .\places.sqlite %PROFILEDIR%\ > NUL

:: szepenet CA
if EXIST .\certdbs\szepenet-cert8.db if EXIST .\certdbs\szepenet-key3.db if EXIST .\certdbs\szepenet-secmod.db (
    copy /Y .\certdbs\szepenet-cert8.db %PROFILEDIR%\ > NUL
    copy /Y .\certdbs\szepenet-key3.db %PROFILEDIR%\ > NUL
    copy /Y .\certdbs\szepenet-secmod.db %PROFILEDIR%\ > NUL
)

:: Flash plugin
rem mkdir "%CORE_DIR%\plugins\"
rem copy "%SystemRoot%\SysWOW64\Macromed\Flash\NPSWF32_"*.dll "%CORE_DIR%\plugins\"

:: Search engines
if EXIST .\search-google1.xml (
    mkdir %PROFILEDIR%\searchplugins
    copy /Y .\search-google1.xml %PROFILEDIR%\searchplugins\ > NUL
)
if EXIST .\search-google-ipv6.xml (
    mkdir %PROFILEDIR%\searchplugins
    copy /Y .\search-google-ipv6.xml %PROFILEDIR%\searchplugins\ > NUL
)

:: Extension version check (XML response)
:: Latest version: https://addons.mozilla.org/firefox/downloads/latest/$SLUG/
:: https://wiki.mozilla.org/AMO:Users/Checking_For_Updates
:: https://addons.mozilla.org/update/VersionCheck.php?reqVersion=1&id=%EXT_ID%&version=%EXT_VER%&maxAppVersion=43.0&status=userEnabled&appID={ec8030f7-c20a-464f-9b0e-13a3a9e97384}&appVersion=46.0.1&appOS=WINNT&appABI=x86_64-msvc&locale=en-US&currentAppVersion=46.0.1&updateType=97&compatMode=normal

:: uBlock Origin extension
rem DELETE FROM settings WHERE name != "advancedUserEnabled" and name != "webrtcIPAddressHidden";
call :Install_extension ".\uBlock0@raymondhill.net.xpi" "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/addon-607454-latest.xpi"

:: dotjs extension
call :Install_extension ".\jid0-HC7vB1GcMVr7IBB5B5ADUjTJB3U@jetpack.xpi" "https://addons.mozilla.org/firefox/downloads/latest/285518/platform:5/addon-285518-latest.xpi"

:: Always Right extension
call :Install_extension ".\jid0-SzimoL45Ib8OddgoUBG0buQmjec@jetpack.xpi" "https://addons.mozilla.org/firefox/downloads/latest/273653/addon-273653-latest.xpi"

:: Copy as Markdown extension
call :Install_extension ".\jid1-tfBgelm3d4bLkQ@jetpack.xpi" "https://addons.mozilla.org/firefox/downloads/latest/copy-as-markdown/addon-505088-latest.xpi"

:: VivaldiFox
call :Install_extension ".\vivaldifox-2.2-an+fx.xpi" "https://addons.mozilla.org/firefox/downloads/file/783770/vivaldifox-2.2-an+fx.xpi"

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

:Install_extension
set EXT_NAME=%1
set EXT_URL=%2
if NOT EXIST %EXT_NAME% (
    wget -nv -O %EXT_NAME% %EXT_URL%
)
if EXIST %EXT_NAME% copy /Y %EXT_NAME% .\%CORE_DIR%\browser\extensions\ > NUL
goto :EOF

:: Bookmarks
Hungarian Dictionary - kw:hu - https://addons.mozilla.org/en-US/firefox/addon/hungarian-dictionary/
I'm feeling luck - kw:1 - https://encrypted.google.com/search?btnI=1&pws=0&q=%s
bgp.he.net - kw:w - http://bgp.he.net/ip/%s
ip-info - kw:i - http://szepeviktor.github.io/ip-info/?%s
mxtoolbox blacklists - kw:b - http://mxtoolbox.com/SuperTool.aspx?action=blacklist%3a%s
Qwant - https://www.qwant.com/opensearch-ff.xml

:: Google consent cookie
document.cookie = "CONSENT=YES+HU.hu+V2;domain=.google.hu;expires=Sun, 10-Jan-2038 07:59:59 GMT;path=/";

:: ABP filters
http://preview.tinyurl.com/adblockhu-subscribe
http://preview.tinyurl.com/adblock-leanfilter
