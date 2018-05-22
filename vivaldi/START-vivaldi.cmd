@echo off

:: Without quotes
set CHROMIUM_NAME=Vivaldi
set CHROMIUM_DIR=C:\usr\vivaldi
set CHROMIUM_BIN=vivaldi.exe

:: Show data directory
set HOME_URL="chrome://version"
title Starting %CHROMIUM_NAME% ...

if NOT EXIST %CHROMIUM_DIR%\%CHROMIUM_BIN% exit 1

call :Exit_if_running

:: http://peter.sh/experiments/chromium-command-line-switches/
start "%CHROMIUM_NAME%" %CHROMIUM_DIR%\%CHROMIUM_BIN% ^
    --lang=en-US ^
    --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0" ^
    --disk-cache-size=1 ^
    --no-proxy-server ^
    --safebrowsing-disable-auto-update ^
    --disable-translate ^
    %HOME_URL%
::    --enable-blink-features=EnumerateDevices,AudioOutputDevices ^
::    --user-data-dir="%CHROMIUM_DIR%\Data" ^
::    --safebrowsing-disable-download-protection ^
::    --enable-ipv6 ^
::    --disable-extensions ^

goto :EOF

:Exit_if_running
wmic process where "name='%CHROMIUM_BIN%'" get ExecutablePath /format:list 2> NUL | find /I "%CHROMIUM_DIR%\%CHROMIUM_BIN%" > NUL
if NOT ERRORLEVEL 1 exit 1
goto :EOF
