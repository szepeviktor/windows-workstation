@echo off

set CHROMIUM_DIR=C:\usr\google-chrome
set HOME_URL="chrome://version"

if NOT EXIST %CHROMIUM_DIR%\chrome.exe exit 1

:: http://peter.sh/experiments/chromium-command-line-switches/
start "Chrome" %CHROMIUM_DIR%\chrome.exe --safebrowsing-disable-auto-update ^
    --lang=en-US --no-proxy-server --disable-translate ^
    --disk-cache-size=1 %HOME_URL%
:: --user-data-dir="%CHROMIUM_DIR%\Data"
:: --safebrowsing-disable-download-protection --enable-ipv6 --disable-extensions

:: Show data dir
::     chrome://version/
