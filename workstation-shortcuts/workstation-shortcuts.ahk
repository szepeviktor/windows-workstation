/*
# Assign Windows key and other shortcuts.
#
# VERSION       :0.1.0
# DATE          :2015-09-18
# AUTHOR        :Viktor Szépe <viktor@szepe.net>
# URL           :https://github.com/szepeviktor/windows-workstation/blob/master/workstation-shortcuts
# LICENSE       :The MIT License (MIT)
# AUTOHOTKEY    :1.1+
# DEPENDS       :http://ahkscript.org/download/
# DOCS          :http://windows.microsoft.com/en-us/windows-10/keyboard-shortcuts
# LOCATION      :C:\bin\workstation-shortcuts\workstation-shortcuts.ahk 
*/

; @TODO
; - Compile https://www.autohotkey.com/docs/Scripts.htm#ahk2exe

/**
 * Syntax for hotkeys
 *
 * ^ CTRL
 * ! ALT
 * + SHIFT
 * # WIN
 * other special keys: http://ahkscript.org/docs/commands/Send.htm
 * not necessary: HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoWinKeys=1
 */

;Directives
#SingleInstance
#Persistent

; Tray
Menu, tray, NoStandard
Menu, tray, add, Edit script, EditThisScript
Menu, tray, add, Exit, ExitHandler
Menu, tray, Icon, %A_ScriptDir%\workstation-shortcuts.ico, 1
Menu, tray, Tip, Workstation Shortcuts

; Globals
BinDir := "C:\bin"
Return

ExitHandler:
ExitApp
Return

#0::
Run, "%ComSpec%" /K cd %TMP%
TrayTip, cmd, Command Prompt, 5, 16+1
Return

#1::
Run, "%windir%\system32\SnippingTool.exe"
TrayTip, >8, Snipping Tool, 5, 16+1
Return

#2::
Run, "StikyNot.exe"
TrayTip, Sticky Notes,, 5, 16+1
Return

#a::
Run, "C:\a\Program Files\Oracle\VirtualBox\VirtualBox.exe" --comment "szerver4-klón" --startvm "c4db4f9b-60a6-473b-9219-1ad64854ba91"
TrayTip, szerver4f, Virtualbox machine, 5, 16+1
Return

#b::
Run "E:\browser-appliance\START-ba.cmd"
TrayTip, Browser Appliance,, 5, 16+1
Return

#c::
Run, "%BinDir%\utl\CCalc.exe"
TrayTip, CCalc, Console Calculator, 5, 16+1
Return

#d::

#i::
Run, "%ProgramFiles%\IrfanView\i_view64.exe"
TrayTip, IrfanView, A compact, easy to use image viewer, 5, 16+1
Return

#k::
Run, "%BinDir%\keepass\KeePass.exe"
TrayTip, KeePass, Authentication database, 5, 16+1
Return

#r::
Run, "explorer.exe" shell:::{2559a1f3-21d7-11d4-bdaf-00c04f60b9f0}
TrayTip, Run..., Run programs, 5, 16+1
Return

#s::
Run, "compmgmt.msc"
TrayTip, Computer Management,, 5, 16+1
Return

#t::
Run, "%ProgramFiles%\totalcmd\TOTALCMD64.EXE"
TrayTip, TCMD, Total Commander, 5, 16+1
Return

#v::
Run, "SndVol.exe"
TrayTip, Volume Control,, 5, 16+1
Return

#w::
Run, "%BinDir%\utl\notepad2.exe"
TrayTip, Notepad2,, 5, 16+1
Return

#y::
Run, "%BinDir%\utl\putty" -load vps
TrayTip, Putty, SSH connection to "VPS", 5, 16+1
Return

#z::
#F4::
TrayTip, Shutdown, System shutdown in 10 seconds, 5, 16+1
ShutDownGui()
Return

;; WIN + "/" -> WIN + "+"
;#NumpadDiv::
;Run, "magnify.exe"
;Return

EditThisScript:
#F12::
Run, "%BinDir%\utl\notepad2.exe" "%A_ScriptFullPath%"
Return

; Monitor off (DPMS)
^!r::
Sleep 1000
SendMessage, 0x112, 0xF170, 2,, Program Manager
Return

^!+c::
Run, "diskpart.exe" /s "%BinDir%\utl\cyg-disk.dpt"
TrayTip, Cygwin mount,, 5, 16+1
Return

^!+d::
TrayTip, Eject optical drive,, 5, 16+1
Drive, Eject
if A_TimeSinceThisHotkey < 500
    Drive, Eject,, 1
Return

^!+m::
; Still 32 bit
ProgramFilesX86 := A_ProgramFiles . (A_PtrSize=8 ? " (x86)" : "")
Run, "%ProgramFilesX86%\MuseScore 2\bin\MuseScore.exe"
TrayTip, MuseScore,, 5, 16+1
Return

^!+r::
Run, "%ProgramFiles%\MuseScore 2\mscore.exe"
TrayTip, System reboot, Restart the computer, 5, 16+1
Return

Browser_Home::
FF_PID := ProcessExist("firefox.exe")
IfWinExist ahk_pid %FF_PID%
{
    WinActivate
}
Else
{
    Run, "%USERPROFILE%\Desktop\ff-dev.lnk",,, CMD_PID
    Sleep 500
    WinHide, ahk_pid %CMD_PID%
}
TrayTip, Firefox, Mozilla Firefox browser, 5, 16+1
Return

Launch_Mail::
Run "%USERPROFILE%\Desktop\v-fõkönyv-2014.xls"
TrayTip, fõkönyv,, 5, 16+1
Return


;WIN + X menu
;^!x::ControlClick, Start1, ahk_class Shell_TrayWnd,, R

^!p::
Run "C:\a\Program Files (x86)\Adobe\Photoshop Elements 11\PhotoshopElementsEditor.exe"
TrayTip, PSE, Photoshop Elements, 5, 16+1
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
    global BinDir
    TenthSeconds := Seconds * 10
    BreakShutdown := 0
    Loop, %TenthSeconds% {
        Sleep, 100
        if (BreakShutdown) {
            return
        }
    }
    Gui, Destroy
    ;Backup
    TrayTip, Backup, Backing up ..., 120, 1+16
    RunWait, "%BinDir%\backup\backup-workstation.cmd",, Max
    TrayTip, Shutdown, Shuting down ..., 60, 2+16
    Shutdown, 1+8
}

ProcessExist(Name){
	Process, Exist, %Name%
	Return Errorlevel
}
