@echo OFF
::
:: List all "shell:" commands (folders)
::
:: Usage
::
:: Open "Run ..." dialog box and copy a "shell:" command
:: or use "start shell:FOLDERNAME" in a batch file.

set SHELL_KEYNAME="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\FolderDescriptions"

setlocal EnableDelayedExpansion

for /F  %%S IN ('reg query %SHELL_KEYNAME%') DO (
    call :REGREAD "%%S" "Name"
    echo shell:!DATA!
)

setlocal DisableDelayedExpansion

pause

goto :EOF

:REGREAD
:: Must be global to return %DATA%
for /F "skip=2 tokens=2,*" %%A in ('reg QUERY %1 /v %2') do set DATA=%%B
goto :EOF
