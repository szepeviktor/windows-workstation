@echo off
::
:: Browser appliance.
::
:: AUTHOR       :Viktor Szépe <viktor@szepe.net>
:: DEPENDS      :7za.exe from 7z*-extra.7z in http://sourceforge.net/projects/sevenzip/files/7-Zip/
:: DEPENDS      :wget.exe https://eternallybored.org/misc/wget/
:: DOCS         :https://github.com/szepeviktor/windows-workstation#wget
:: RELEASE      :https://basilisk-browser.org/releasenotes.shtml
:: EXTRA_PREF   :user_pref("security.tls.version.min", 3);

set HOME_URL="https://www.otpbank.hu/portal/hu/OTPdirekt/Belepes"
set SETUP_URL="http://eu.basilisk-browser.org/release/basilisk-latest.win64.7z"

:: Make sure we are in batch file's directory
cd /D %~dp0
call :Exit_if_running "%CD%"

:: Download installer
title Checking/downloading installer ...
if NOT EXIST .\"basilisk-latest.win64.7z" wget -nv --content-disposition %SETUP_URL%
7za l -y .\"basilisk-latest.win64.7z" > NUL || (
    del /Q .\"basilisk-latest.win64.7z"
    wget -nv --content-disposition %SETUP_URL%
    7za l -y .\"basilisk-latest.win64.7z" > NUL || exit 2
)

:: Show the current directory in window title
title %CD%

:: Unpack installer - Don't use ".\basilisk\"
7za x -y .\"basilisk-latest.win64.7z" "basilisk\"
:: Prevent pending updates
rmdir /Q /S %LOCALAPPDATA%\Mozilla\Firefox\firefox\updates\ > NUL 2>&1
set PROFILEDIR=".\data"
mkdir %PROFILEDIR%

:: Remove built-in certificates
del /Q .\basilisk\nssckbi.dll

:: Premade certificate and key databases
copy /Y .\certificates\* %PROFILEDIR%\

:: Settings
if EXIST .\user.js copy /Y .\user.js %PROFILEDIR%\ > NUL

:: Start Browser
title %CD% - Started
start /WAIT .\basilisk\basilisk.exe -safe-mode -no-remote -profile %PROFILEDIR% %HOME_URL%

:: Remove Browser
title %CD% - Exiting...
rmdir /S /Q %PROFILEDIR%
rmdir /S /Q .\basilisk\

exit /B 0

:Exit_if_running
wmic process where "name='basilisk.exe'" get ExecutablePath /format:list 2> NUL | find /I "%~1\basilisk\basilisk.exe" > NUL
if NOT ERRORLEVEL 1 exit 1
goto :EOF
