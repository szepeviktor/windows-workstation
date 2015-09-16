@echo off

:: Backup parameters
set BACKUP_ROOT="E:\backup"
set ENC="l=:#bvMV+2RkMp6FFm7k"

:: Window title
title Backup workstation %COMPUTERNAME%

:: Green characters
color 02

:: Test zpaq
zpaq64.exe add test.zpaq . -test -method 11 > nul 2>&1
if ERRORLEVEL 1 (
    color 0C
    echo Missing ZPAQ binary.
    exit 1
)

:: Windows Theme
call :ZPAQA "%LOCALAPPDATA%\Microsoft\Windows\Themes" windows-themes

:: HotKeyz
call :ZPAQA "%LOCALAPPDATA%\Hotkeyz" hotkeyz

:: Launchy
call :ZPAQA "%APPDATA%\Launchy\Launchy.ini" launchy

:: Desktop
call :REGREAD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" "Desktop"
call :ZPAQA %DATA% desktop

pause
:: -- END -- ::
goto :EOF

:ZPAQA
zpaq64.exe add %BACKUP_ROOT%\%2-?????.zpaq %1 -method 44 -key %ENC%
goto :EOF

:REGREAD
set REG_KEY=%1
set REG_VALUE=%2
for /F "tokens=3*" %%A in ('reg QUERY %REG_KEY% /v %REG_VALUE%') do set DATA="%%A"
goto :EOF
