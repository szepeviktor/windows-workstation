@echo off
title Starting Chromium ...

set CHROMIUM_DIR=C:\usr\chromium
:: Show data dir
set HOME_URL="chrome://version"

if NOT EXIST %CHROMIUM_DIR%\chrome.exe exit 1

call :Exit_if_running "%CHROMIUM_DIR%"

:: http://peter.sh/experiments/chromium-command-line-switches/
start "Chromium" %CHROMIUM_DIR%\chrome.exe --safebrowsing-disable-auto-update ^
    --lang=en-US --no-proxy-server --disable-translate ^
    --disk-cache-size=1 %HOME_URL% --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0"
:: --user-data-dir="%CHROMIUM_DIR%\Data"
:: --safebrowsing-disable-download-protection --enable-ipv6 --disable-extensions

goto :EOF

:Exit_if_running
wmic process where "name='chrome.exe'" get ExecutablePath /format:list 2> NUL | find /I "%~1\chrome.exe" > NUL
if NOT ERRORLEVEL 1 exit 1
goto :EOF
