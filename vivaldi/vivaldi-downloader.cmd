@echo off
::
:: Update Vivaldi browser.
::
:: AUTHOR       :Viktor Szépe <viktor@szepe.net>
:: DOCS         :https://vivaldi.com/download/
:: DEPENDS      :wget.exe from https://eternallybored.org/misc/wget/
:: DEPENDS      :7z.exe from 7z1805-x64.exe at http://sourceforge.net/projects/sevenzip/files/7-Zip/

:: Download for Windows 64bit
FOR /F delims^=^"^ tokens^=4 %%U IN ('wget -qO- "https://vivaldi.com/download/"^|find ".x64.exe"') DO (
    ECHO %%U | wget -i -
)

:: Extract vivaldi.7z
FOR %%V IN (Vivaldi.*.x64.exe) DO "%ProgramFiles%\7-zip\7z.exe" e %%V
:: Extract files from vivaldi.7z
"%ProgramFiles%\7-zip\7z.exe" x vivaldi.7z
DEL /Q Vivaldi.*.x64.exe vivaldi.7z

:: Remove updater
DEL /Q Vivaldi-bin\update_notifier.exe
:: Move files in place
MOVE /Y Vivaldi-bin\vivaldi.exe .
FOR /D %%V IN (Vivaldi-bin\1.*.*) DO MOVE /Y %%V .
RMDIR /Q Vivaldi-bin

PAUSE
