rem @echo off

FOR /F delims^=^"^ tokens^=4 %%U IN ('wget -qO- "https://vivaldi.com/download/"^|find ".x64.exe"') DO (
    ECHO %%U | wget -i -
)

:: Unpack
FOR %%V IN (Vivaldi.*.x64.exe) DO "%ProgramFiles%\7-zip\7z.exe" e %%V
"%ProgramFiles%\7-zip\7z.exe" x vivaldi.7z
DEL /Q Vivaldi.*.x64.exe vivaldi.7z

:: Update
DEL /Q Vivaldi-bin\update_notifier.exe
MOVE /Y Vivaldi-bin\vivaldi.exe .
FOR /D %%V IN (Vivaldi-bin\1.*.*) DO MOVE /Y %%V .
RMDIR /Q Vivaldi-bin

PAUSE
