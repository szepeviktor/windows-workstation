@echo off & goto :START
#
# Assign Windows key and other shortcuts.
#
# VERSION       :1.2.0
# DATE          :2015-10-11
# AUTHOR        :Viktor Szépe <viktor@szepe.net>
# URL           :https://github.com/szepeviktor/windows-workstation/tree/master/backup
# LICENSE       :The MIT License (MIT)
# ENCODING      :UTF-8
# DEPENDS       :http://mattmahoney.net/dc/zpaq.html
# CONFIG        :C:\bin\backup\backup-auth.files
# LOCATION      :C:\bin\backup\backup-workstation.cmd

# Restore
#
# set BACKUP_ZPAQ=backup.zpaq
# for /F "tokens=*" %E IN (enc.key) DO zpaq64.exe extract %BACKUP_ZPAQ% -all -key "%E"

:START
:: Everything is comment before this label

:: Backup parameters
set BACKUP_ROOT="E:\backup"
:: No quotes!
set ENC_KEY=C:\bin\backup\enc.key
:: Things to backup
set BCK_BACKUP="C:\bin\backup"
set BCK_AUTH="C:\bin\backup\backup-auth.files"
set BCK_REG="E:\reg"
set BCK_UTL="C:\bin\utl\*.cmd"

:: UTF-8 output
chcp 65001 > nul

:: Window title
title Backup workstation %COMPUTERNAME%

:: Green characters on black
color 02

:: Check zpaq
zpaq64.exe add "" . > nul 2>&1
if ERRORLEVEL 1 call :ERROR_MSG "Missing ZPAQ binary."

:: Check backup target folder
if NOT EXIST %BACKUP_ROOT% call :ERROR_MSG "Backup target folder not found."

:: Read in encryption key
if NOT EXIST %ENC_KEY% call :ERROR_MSG "Encryption key file is missing."
for /F "tokens=*" %%E IN (%ENC_KEY%) DO set ENC="%%E"

:: Backup - backup scripts
call :ZPAQA backup %BCK_BACKUP%

:: Backup - authentication data
call :ZPAQLIST auth %BCK_AUTH%

:: Backup - licence files, paid software
call :ZPAQA reg %BCK_REG%

:: Backup - utilities
call :ZPAQA utl %BCK_UTL%

::--------------------------------------

:: Total Comamnder settings
call :ZPAQA tcmd "%APPDATA%\GHISLER"

:: IrfanViewr settings
call :ZPAQA irfanv "%APPDATA%\IrfanView"

:: Windows Theme
call :ZPAQA windows-themes "%LOCALAPPDATA%\Microsoft\Windows\Themes"

:: Launchy settings
call :ZPAQA launchy "%APPDATA%\Launchy\Launchy.ini"

:: Skype profile
tasklist /FI "IMAGENAME eq Skype.exe" > nul && taskkill /T /F /FI "IMAGENAME eq Skype.exe" > nul
call :ZPAQA skype "%APPDATA%\Skype"

:: Desktop
call :REGREAD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" "Desktop"
call :ZPAQA desktop %DATA%

:: Whole user profile
rem call :ZPAQA desktop %USERPROFILE%

:: Putty sessions
call :ZPAQREG putty "HKCU\Software\SimonTatham\PuTTY\Sessions"

set "ENC="

rem echo DBG & pause

:: -- THE END -- ::
goto :EOF

:ERROR_MSG
:: Display error message and exit with errorlevel 10( message... )
set "ENC="
color 0C
:: Trim double-quotes
for /F "tokens=*" %%M IN (%*) do echo %%~M 1>&2
pause
exit 10
goto :EOF

:ZPAQA
:: Add files to archive( name, file... )
setlocal
set NAME=%1
title Backing up %NAME% ...
echo --- %NAME% ---
set "FILES="
shift
:_allfiles_add
if "%FILES%" == "" (set FILES=%1) else (set FILES=%FILES% %1)
shift
if NOT "%1" == "" goto :_allfiles_add
:: Don't keep previous versions: -until 0
zpaq64.exe add %BACKUP_ROOT%\bck-%NAME%.zpaq %FILES% -until 0 -method 44 -key %ENC% || call :ERROR_MSG "Archiving failed: %NAME%"
echo.
title Backup workstation %COMPUTERNAME%
endlocal
goto :EOF

:ZPAQREG
:: Archive a registry key( name, key )
setlocal
set NAME=%1
set REG_KEY=%2
reg EXPORT %REG_KEY% %BACKUP_ROOT%\%NAME%.reg /Y > nul || call :ERROR_MSG "Registry export failed: %NAME%"
call :ZPAQA %NAME% %BACKUP_ROOT%\%NAME%.reg
del %BACKUP_ROOT%\%NAME%.reg || call :ERROR_MSG "Cannot delete registry export file: %NAME%"
endlocal
goto :EOF

:PARAMSADD
:: Add all strings to %PARAMS%( string... )
if "%PARAMS%" == "" (set PARAMS=%*) else (set PARAMS=%PARAMS% %*)
goto :EOF

:ZPAQLIST
:: Add files from a list file to archive( name, file... )
setlocal
set NAME=%1
set "FILES="
shift
:_allfiles_list
if "%FILES%" == "" (set FILES=%1) else (set FILES=%FILES% %1)
shift
if NOT "%1" == "" goto :_allfiles_list
set "PARAMS="
for /F "tokens=*" %%F in ('type %FILES%') do call :PARAMSADD "%%F"
call :ZPAQA %NAME% %PARAMS%
endlocal
goto :EOF

:REGREAD
:: Read a registry key and return it in %DATA%( key )
for /F "tokens=2,*" %%A in ('reg QUERY %1 /v %2') do set DATA="%%B"
goto :EOF
