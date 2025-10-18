/*
# Assign Windows key and other shortcuts.
#
# ENCODING      :ANSI or UTF-8 BOM
# VERSION       :0.3.2
# DATE          :2015-09-18
# AUTHOR        :Viktor Szépe <viktor@szepe.net>
# URL           :https://github.com/szepeviktor/windows-workstation/blob/master/workstation-shortcuts
# LICENSE       :The MIT License (MIT)
# AUTOHOTKEY    :1.1+
# DEPENDS       :https://www.autohotkey.com/download/
# DOCS          :https://support.microsoft.com/en-us/windows/keyboard-shortcuts-in-windows-dcc61a57-8ff0-cffe-9796-cb9706c75eec
# LOCATION      :C:\usr\workstation-shortcuts\workstation-shortcuts.ahk 
*/

; @TODO
; - Compile https://www.autohotkey.com/docs/v1/Scripts.htm#ahk2exe

/**
 * Syntax for hotkeys
 *
 * ^ CTRL
 * ! ALT
 * + SHIFT
 * # WIN
 * other special keys: https://www.autohotkey.com/docs/v1/lib/Send.htm
 * not necessary: HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoWinKeys=1
 */

; Directives
#SingleInstance
#Persistent

; Tray
Menu, tray, NoStandard
Menu, tray, add, Shutdown, ShutDownNow
Menu, tray, add, Edit script, EditThisScript
Menu, tray, add, Exit, ExitHandler
Menu, tray, Icon, %A_ScriptDir%\workstation-shortcuts.ico, 1
Menu, tray, Tip, Workstation Shortcuts

; Globals
UsrDir := "C:\usr"
Return

ExitHandler:
ExitApp
Return

SetCapsLockState, AlwaysOff 
Capslock::Shift
Return

;MButton & WheelDown::
;Send {Enter}
;Return

#0::
Run, "%ComSpec%" /K cd %TMP%
TrayTip, cmd, Command Prompt, 5, 1+16
Return

#1::
Run, "%windir%\system32\SnippingTool.exe", %USERPROFILE%
TrayTip, >8, Snipping Tool, 5, 1+16
Return

#2::
Run, "shell:AppsFolder\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe!App", %USERPROFILE%
TrayTip, Sticky Notes,, 5, 1+16
Return

#3::
FormatTime, CurrentDateTime,, yyyyMMdd
SendInput %CurrentDateTime%
TrayTip, Today,, 5, 1+16
Return

#4::
SetKeyDelay 70
/* Join Two Cells in Excel
- Cut
- Up
- F2 (edit cell contents)
- Space
- Paste
- Enter
- Ctrl+Shift+Delete (delete cell)
- Down
*/
Send ^x{Up}{F2}{Space}+{Insert}{Enter}^+{Delete}{Down}
Return

#7::
; Type a with macron
Send {U+0101}
Return

#a::
; Open Action Center
ControlGet, ShellTray, Hwnd,, TrayButton1, ahk_class Shell_TrayWnd
ControlClick,, ahk_id %ShellTray%
Return

#b::
Run "%UsrDir%\otp\START-otp.cmd", %USERPROFILE%
TrayTip, Browser Appliance,, 5, 1+16
Return

#c::
Run, "%UsrDir%\bin\CCalc.exe", %USERPROFILE%
WinWait, Console Calculator
WinActivate
TrayTip, CCalc, Console Calculator, 5, 1+16
Return

#d::
Run, "C:\a\Program Files\Oracle\VirtualBox\VirtualBox.exe" --comment "szerver4-klón" --startvm "c4db4f9b-60a6-473b-9219-1ad64854ba91", %USERPROFILE%
TrayTip, szerver4f, Virtualbox machine, 5, 1+16
Return

#e::
Run, "explorer.exe"
TrayTip, Explorer, Windows Explorer, 5, 1+16
Return

#i::
Run, "%ProgramFiles%\IrfanView\i_view64.exe", %USERPROFILE%
TrayTip, IrfanView, A compact`, easy to use image viewer, 5, 1+16
Return

#k::
Launch_Mail::
Run, "%UsrDir%\keepass\KeePass.exe", %USERPROFILE%
TrayTip, KeePass, Authentication database, 5, 1+16
Return

#r::
Run, "explorer.exe" shell:::{2559a1f3-21d7-11d4-bdaf-00c04f60b9f0}
TrayTip, Run..., Run programs, 5, 1+16
Return

#s::
Run, "compmgmt.msc"
TrayTip, Computer Management,, 5, 1+16
Return

#t::
Run, "%ProgramFiles%\totalcmd\TOTALCMD64.EXE", %USERPROFILE%
TrayTip, TCMD, Total Commander, 5, 1+16
Return

#v::
Run, "SndVol.exe", %USERPROFILE%
TrayTip, Volume Control,, 5, 1+16
Return

#w::
Sleep 300
Run, "%UsrDir%\bin\notepad2.exe", %USERPROFILE%
TrayTip, Notepad2,, 5, 1+16
Return

#y::
Run, "%UsrDir%\bin\putty.exe" -load szepe.contabo, %USERPROFILE%
TrayTip, Putty, SSH connection to mail.szepe.net, 5, 1+16
Return

~LAlt & WheelUp::
;                         "A" The Active Window
ControlGetFocus, fcontrol, A
Loop 2
    ; Scroll left
    ;       WM_HSCROLL, SB_LINELEFT
    SendMessage, 0x114, 0, 0, %fcontrol%, A
Return

; https://wiki.mozilla.org/Gecko:Mouse_Wheel_Scrolling
~LAlt & WheelDown::
ControlGetFocus, fcontrol, A
Loop 2
    ; Scroll right
    SendMessage, 0x114, 1, 0, %fcontrol%, A
Return

ShutDownNow:
#z::
#F4::
^!+r::
TrayTip, Shutdown, System shutdown in 10 seconds, 5, 1+16
ShutDownGui()
Return

;; WIN + "/" -> WIN + "+"
;#NumpadDiv::
;Run, "magnify.exe"
;Return

EditThisScript:
#F12::
Run, "%UsrDir%\bin\notepad2.exe" "%A_ScriptFullPath%"
Return

; Monitor off (DPMS)
^!r::
Sleep 1000
SendMessage, 0x112, 0xF170, 2,, Program Manager
Return

^!+c::
Run, "diskpart.exe" /s "%UsrDir%\bin\cyg-disk.dpt", %USERPROFILE%
TrayTip, Cygwin mount,, 5, 1+16
Return

^!+d::
TrayTip, Eject optical drive,, 5, 1+16
Drive, Eject
if A_TimeSinceThisHotkey < 500
    Drive, Eject,, 1
Return

^!+m::
; Still 32 bit
ProgramFilesX86 := A_ProgramFiles . (A_PtrSize=8 ? " (x86)" : "")
Run, "%ProgramFilesX86%\MuseScore 2\bin\MuseScore.exe", %USERPROFILE%
TrayTip, MuseScore,, 5, 1+16
Return

Browser_Home::
Media_Play_Pause::
FF_PID := ProcessExist("waterfox.exe")
IfWinExist ahk_pid %FF_PID%
{
    WinActivate
}
Else
{
    Run, "%USERPROFILE%\Desktop\Waterfox.lnk",,, CMD_PID
    Sleep 500
    WinHide, ahk_pid %CMD_PID%
}
TrayTip, Firefox, Mozilla Firefox browser, 5, 1+16
Return

#f::
Run %USERPROFILE%\Desktop\v-fõkönyv.lnk, %USERPROFILE%\Desktop
TrayTip, fõkönyv,, 5, 1+16
Return


;WIN + X menu
;^!x::ControlClick, Start1, ahk_class Shell_TrayWnd,, R

^!p::
Run "C:\a\Program Files (x86)\Adobe\Photoshop Elements 11\PhotoshopElementsEditor.exe", %USERPROFILE%
TrayTip, PSE, Photoshop Elements, 5, 1+16
Return

ShutDownGui() {
    Gui, New, +Resize +MinSize320x160 +LabelMyGui_On, Abandon shutdown
    Gui, Font, s36 wbold
    Gui, Add, Button, gAbandonButton Default yp20 w240 h80, ` STOP!` 
    Gui, Show
    ShutDownIn(10)
    Return

    AbandonButton:
    global BreakShutdown
    BreakShutdown := 1
    Gui, Destroy
    Return
}

ShutDownIn(Seconds) {
    global BreakShutdown
    global UsrDir
    TenthSeconds := Seconds * 10
    BreakShutdown := 0
    Loop, %TenthSeconds% {
        Sleep, 100
        if (BreakShutdown) {
            return
        }
    }
    Gui, Destroy
    ; Backup
    TrayTip, Backup, Backing up ..., 120, 1+16
    RunWait, "%UsrDir%\backup\backup-workstation.cmd",, Max
    TrayTip, Shutdown, Shuting down ..., 60, 2+16
    Shutdown, 1+8
}

ProcessExist(Name){
	Process, Exist, %Name%
	Return Errorlevel
}

