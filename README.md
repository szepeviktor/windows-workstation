# Prepare my Windows workstation

## Identification

- Name: HP Z210 Convertible Minitower Base Model Workstation
- Model #: XM856AV
- Serial #: CZC13941PV

### Windows 10 "Light"

[Download Windows 10 ISO tool from Microsoft](https://www.microsoft.com/en-us/software-download/windows10)

Windows phone activation: `slui.exe 4`

Reinstall all Apps:

```powershell
Get-AppxPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
```

Remove an App:

```powershell
Get-AppxPackage *skypeapp* | Remove-AppxPackage
```

```batch
:: Remove Windows Spying
:: https://github.com/Nummer/Destroy-Windows-10-Spying

:: Remove all built-in Apps
:: http://www.thewindowsclub.com/ultimate-windows-tweaker-4-windows-10

:: Remove OneDrive
reg ADD "HKLM\Software\Policies\Microsoft\Windows" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f
taskkill /f /im OneDrive.exe
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
rd "%UserProfile%\OneDrive" /Q /S
rd "%LocalAppData%\Microsoft\OneDrive" /Q /S
rd "%ProgramData%\Microsoft OneDrive" /Q /S
rd "C:\OneDriveTemp" /Q /S
reg DELETE "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
reg DELETE "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f

:: Remove Defender
:: C:\Program Files\Windows Defender\MSASCui.exe
:: https://www.raymond.cc/blog/how-to-disable-uninstall-or-remove-windows-defender-in-vista/
"C:\Program Files\Windows Defender\mpcmdrun" -removedefinitions -all
reg ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /T REG_DWORD /d 1 /f
shutdown /t 0 /r
:: Reboot to KNOPPIX (hit F8-F8-F8)
    ntfs-3g.real /dev/sda1 /mnt
    mv "/mnt/Program Files/Windows Defender" "/mnt/Program Files/_Windows Defender"
    :: Dummy file to prevent folder recreation
    touch "/mnt/Program Files/Windows Defender"
:: @FIXME Remove services, drivers: WdFilter.sys, WdNisDrv.sys
rem sc delete WinDefend
rem sc delete WdNisSvc

:: Disable SSDP Discovery service (enumerates UPnP devices)
sc stop SSDPSRV
sc config SSDPSRV start= disabled

:: Disable Remote Registry service
sc stop RemoteRegistry
sc config RemoteRegistry start= disabled

:: Check drivers
:: http://www.nirsoft.net/utils/driverview.html
sc query type= driver | find "_NAME:"

:: https://www.devside.net/wamp-server/opening-up-port-80-for-apache-to-use-on-windows
rem netsh http show urlacl | find "Reserved URL"
rem netsh http show servicestate
rem net stop HTTP
rem sc config HTTP start= disabled

:: Check missing files
Autoruns.exe

:: https://support.microsoft.com/en-us/kb/929833
sfc /VERIFYONLY
rem sfc /SCANNOW
```

[Windows 10 version 1607 Error code: 0x8024200D WU_E_UH_NEEDANOTHERDOWNLOAD](https://msdn.microsoft.com/en-us/library/dd939837.aspx)

### Hardware related software

#### BIOS update

[HP Support](http://h20564.www2.hp.com/hpsc/swd/public/readIndex?sp4ts.oid=5053200&swLangOid=8&swEnvOid=4059)

#### Applications

- [Intel® Driver Update Utility](http://www.intel.com/support/detect.htm)
- [CPUZ](http://www.cpuid.com/softwares/cpu-z.html) Disable monitoring
- [HWMonitor](http://www.cpuid.com/softwares/hwmonitor.html)
- [S.M.A.R.T. status viewer](http://www.passmark.com/products/diskcheckup.htm)
- [HP SoftPaq Download Manager](http://www8.hp.com/us/en/ads/clientmanagement/drivers-bios.html)
- [HP Support Assistant](http://www8.hp.com/us/en/campaigns/hpsupportassistant/hpsupport.html)
- [Fujitsu DeskUpdate](http://support.ts.fujitsu.com/DeskUpdate/)
- [Lenovo ThinkVantage System Update](https://support.lenovo.com/us/en/documents/tvsu-update)
- [NVIDIA QFE driver](http://www.nvidia.com/Download/Find.aspx?lang=en-us&QNF=1) (Quadro New Feature)
- [DirectX](http://www.microsoft.com/en-us/download/details.aspx?id=35)

### Windows settings

#### Drive labels

```batch
label C: system
label E: data
```

#### Boot display

[BCDEdit /set reference](https://msdn.microsoft.com/en-us/library/windows/hardware/ff542202%28v=vs.85%29.aspx)

```batch
bcdedit /set quietboot on
bcdedit /set sos on
```

#### Hibernation

```batch
powercfg -h on
:: powercfg -h off
powercfg.cpl
:: Power button: shutdown, Sleep button: hibernate
:: Hibernate command: shutdown /t 0 /f /h
```

#### Disable Windows key combinations (user)

```batch
reg ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWinKeys" /t REG_DWORD /d 1 /f
```

https://support.microsoft.com/help/12445/windows-keyboard-shortcuts

#### Show known file extensions (user)

```batch
reg ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f
```

#### Don't display delete confirmation (user)

```batch
reg ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ConfirmFileDelete" /t REG_DWORD /d 0 /f
```

#### Disable NTFS last access update

If you have spinning drives.

```batch
reg ADD "HKCU\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 0 /f
```

#### Disable Terminal Server aka. remote assistance

```batch
reg ADD "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 1 /f
```

#### Show analogue clock

```batch
reg ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v "UseWin32TrayClockExperience" /t REG_DWORD /d 1 /f
```

#### Untrusted Font Blocking in IE

gpedit.msc / Administrative Templates / System / Mitigation Options / Untrusted Font Blocking / "Do not block untrusted fonts"

#### Settings commands

[Control Panel Items](https://msdn.microsoft.com/en-us/library/ee330741(VS.85).aspx#DefaultPrograms)

```
All  shell:::{ED7BA470-8E54-465E-825C-99712043E01C}
Battery Saver  ms-settings:batterysaver
Battery Saver Settings  ms-settings:batterysaver-settings
Battery use  ms-settings:batterysaver-usagedetails
Bluetooth  ms-settings:bluetooth
Colors  ms-settings:colors
Data Usage  ms-settings:datausage
Date and Time  ms-settings:dateandtime
Closed Captioning  ms-settings:easeofaccess-closedcaptioning
High Contrast  ms-settings:easeofaccess-highcontrast
Magnifier  ms-settings:easeofaccess-magnifier
Narrator  ms-settings:easeofaccess-narrator
Keyboard  ms-settings:easeofaccess-keyboard
Mouse  ms-settings:easeofaccess-mouse
Other Options (Ease of Access)  ms-settings:easeofaccess-otheroptions
Lockscreen  ms-settings:lockscreen
* Offline maps  ms-settings:maps
Airplane mode  ms-settings:network-airplanemode
Proxy  ms-settings:network-proxy
VPN  ms-settings:network-vpn
* Notifications & actions  ms-settings:notifications
* Account info  ms-settings:privacy-accountinfo
Calendar  ms-settings:privacy-calendar
Contacts  ms-settings:privacy-contacts
Other Devices  ms-settings:privacy-customdevices
* Feedback  ms-settings:privacy-feedback
* Location  ms-settings:privacy-location
Messaging  ms-settings:privacy-messaging
Microphone  ms-settings:privacy-microphone
Motion  ms-settings:privacy-motion
Radios  ms-settings:privacy-radios
Speech, inking, & typing  ms-settings:privacy-speechtyping
Camera  ms-settings:privacy-webcam
Region & language  ms-settings:regionlanguage
Speech  ms-settings:speech
* Windows Update  ms-settings:windowsupdate
Work access  ms-settings:workplace
Connected devices  ms-settings:connecteddevices
For developers  ms-settings:developers
Display  ms-settings:display
Mouse & touchpad  ms-settings:mousetouchpad
Cellular  ms-settings:network-cellular
Dial-up  ms-settings:network-dialup
DirectAccess  ms-settings:network-directaccess
* Ethernet  ms-settings:network-ethernet
Mobile hotspot  ms-settings:network-mobilehotspot
* Wi-Fi  ms-settings:network-wifi
Manage Wi-Fi Settings  ms-settings:network-wifisettings
* Optional features  ms-settings:optionalfeatures
Family & other users  ms-settings:otherusers
* Personalization  ms-settings:personalization
Backgrounds  ms-settings:personalization-background
Colors  ms-settings:personalization-colors
Start  ms-settings:personalization-start
Power & sleep  ms-settings:powersleep
Proximity  ms-settings:proximity
Display  ms-settings:screenrotation
Sign-in options  ms-settings:signinoptions
Storage Sense  ms-settings:storagesense
Themes  ms-settings:themes
Typing  ms-settings:typing
Tablet mode  ms-settings://tabletmode/
* Privacy  ms-settings:privacy

* Computer Management  compmgmt.msc
* Windows Features  OptionalFeatures.exe (Add HyperV)
* System Properties  SystemPropertiesAdvanced.exe
* System Performance SystemPropertiesPerformance.exe (Disable animations)
* Remote Desktop (RDP) SystemPropertiesRemote.exe
* Security Center  wscui.cpl
* Firewall  Firewall.cpl
* Power Settings  powercfg.cpl
* Certificate Manager  certmgr.msc
* Mouse  main.cpl (Disable mouse shadow)
* Time and Date  timedate.cpl (Analogue clock)
```

See also: http://ss64.com/nt/shell.html and `utl\shell-commands.cmd` for `shell::` commands.

#### Time

Check RTC: https://toolbox.googleapps.com/apps/browserinfo/

#### Network and ISP

- IPv6 connectivity
- DNS resolvers
- NTP server
- Blocked SMTP port (25/TCP)
- [BCP38 Spoofer](https://spoofer.caida.org/)

#### Fonts

- https://github.com/andreberg/Meslo-Font/releases (LGS=line gap small, DZ=dotted zero)
- http://www.fontsquirrel.com/fonts/open-sans

Usage in cmd.exe:

@FIXME `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont` `000`=`Meslo LG M DZ Regular`

#### Cursors

- Windows built-in "Large inverted"
- See folder: `cursor OS X Yosemite for Windows/`
- [Chrome OS](http://www.deviantart.com/art/Google-Chrome-OS-Pointers-W-I-P-324618673)
- [OS X Yosemite](http://mercury21.deviantart.com/art/New-Mac-OS-X-Cursor-97810609)

### Windows Updates

Disable reboot after update

Task Scheduler Library / Microsoft / Windows / UpdateOchestrator / Reboot right-click / Disable

```batch
reg ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d 1 /f
```

[chmod -x MusNotification.exe](http://superuser.com/a/1006199)

[Windows Update MiniTool](http://forum.ru-board.com/topic.cgi?forum=5&topic=48142#2)

### Applications

- [Dataram RAMDisk](http://memory.dataram.com/products-and-services/software/ramdisk/ramdisk-releases)
- [Visual C++ Redist 2013](http://www.microsoft.com/en-us/download/details.aspx?id=40784)
- [Precise time for Windows](https://www.meinbergglobal.com/english/sw/ntp.htm) (ntpd)
- [Startup Delayer 64](http://www.r2.com.au/page/products/download/startup-delayer/)
- [Notifu](http://www.paralint.com/projects/notifu/#Download)
- [Keypirinha](http://keypirinha.com/)
    - [System Commands](https://github.com/psistorm/keypirinha-systemcommands)
- [ConsoleZ](https://github.com/cbucher/console/wiki)
- [Launchy](http://www.launchy.net/download.php#windows)
    - https://github.com/Netrics/putty-launchy-plugin/releases
    - http://sourceforge.net/projects/tasky-launchy/files/
- [Shapeshifter](https://github.com/ffMathy/Shapeshifter/releases)
- [WinCompose](https://github.com/samhocevar/wincompose)
- [Caret Premium Markdown Editor](https://caret.io/)
- [7-zip 64](http://www.7-zip.org/download.html)
- [CCleaner 64](http://mirror.szepe.net/software/)
- [herdProtect](http://www.herdprotect.com/downloads.aspx) Portable
- [HitmanPro.Alert](http://www.surfright.nl/en/alert) Second opinion behavioral based Anti-Malware, [beta](http://www.surfright.nl/en/downloads/beta) [forum](http://www.wilderssecurity.com/threads/hitmanpro-alert-support-and-discussion-thread.324841/page-307)
- [zpaq 64](http://mattmahoney.net/dc/zpaq.html)
- [bsc 64](http://libbsc.com/)
- [hubiC client](https://hubic.com/en/downloads)
- [Total Commander 64](http://www.ghisler.com/amazons3.php)
- [IrfanView 64](http://www.irfanview.com/64bit.htm)
- [DiffImg](http://thehive.xbee.net/index.php?module=pages&func=display&pageid=11#Downloads)
- [Media Player Classic - BE](https://sourceforge.net/projects/mpcbe/files/MPC-BE/)
- [latest Skype.exe](http://mirror.szepe.net/software/Skype.exe)
    - [Skype Utility Project](https://github.com/dlehn/Skype-Utility-Project/releases)
    - [Skype official full installer](http://www.skype.com/go/getskype-full)
    - Portable: `Skype.exe /datapath:"path\to\profiles" /removable`
    - During call: Call / Call Technical Info
- @TODO [tinyssh on Cygwin](http://tinyssh.org/faq.html)
- [Chromium 64 / NIK stable / No sync / Archive](http://chromium.woolyss.com/)
    - `--safebrowsing-disable-auto-update --lang=en-US --no-proxy-server --disable-translate --disk-cache-size=1`
    - https://fpdownload.adobe.com/pub/flashplayer/latest/help/install_flash_player_ppapi.exe
    - https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm
    - https://chrome.google.com/webstore/detail/tag-assistant-by-google/kejbdjndbnbjgmefkgdddjlbokphdefk
    - https://chrome.google.com/webstore/detail/google-analytics-debugger/jnkmfdileelhofjcijamephohjechhna
    - https://chrome.google.com/webstore/detail/fb-pixel-helper/fdgfkebogiimcoedlicjlajpkdmockpc
    - https://chrome.google.com/webstore/detail/seoquake/akdgnmcogleenhbclghghlkkdndkjdjc
    - https://chrome.google.com/webstore/detail/wappalyzer/gppongmhjkpfnbhagpmjfkannfbllamg
    - https://chrome.google.com/webstore/detail/project-naptha/molncoemjfmpgdkbdlbjmhlcgniigdnf
- [UltraVNC 64](http://www.uvnc.com/downloads/ultravnc.html) Listen on port 5500
- [UltraVNC SC](http://www.uvnc.com/docs/uvnc-sc.html)
- [TeamViewer full version](https://www.teamviewer.com/en/download/windows.aspx)
- [Meneré](https://wordpress.org/support/rss/topic/graphics-for-polylang) Feedly reader
- todotxt winui, cli
- [Libre Office 64](https://www.libreoffice.org/download/libreoffice-fresh/?type=win-x86_64&lang=hu)
- [MuseScore 32](https://musescore.org/hu/let%C3%B6lt%C3%A9s)
- [Miranda NG 64](http://www.miranda-ng.org/en/downloads/) SkypeWeb protocol
- [GIMP 64](http://www.partha.com/)
- [Inkspace 64](http://www.partha.com/)
- [RealWolrd Paint](http://www.rw-designer.com/image-editor)
- Adobe PSE
- [PDF-XChange Viewer](http://www.tracker-software.com/product/pdf-xchange-viewer)
- [Some PDF Images Extract](http://www.somepdf.com/downloads.html)
- [HotShots](http://thehive.xbee.net/index.php?module=pages&func=display&pageid=31#Downloads)
- [Open Broadcaster Software](https://obsproject.com/download)
- [Sizer](http://www.brianapps.net/sizer/)

Also on http://mirror.szepe.net/software/

### Alert on Event log errors

Scheduled task import: `Task-Event log alert.xml`

Exclude "DistributedCOM 10016"

```xml
    <Suppress Path="Application">*[System[(EventID=10016)]]</Suppress>
    <Suppress Path="Security">*[System[(EventID=10016)]]</Suppress>
    <Suppress Path="Setup">*[System[(EventID=10016)]]</Suppress>
    <Suppress Path="System">*[System[(EventID=10016)]]</Suppress>
    <Suppress Path="ForwardedEvents">*[System[(EventID=10016)]]</Suppress>
```

```batch
wevtutil qe Application "/q:*[System[(Level=1  or Level=2 or Level=3)]]" /f:text /rd:true /c:1
wevtutil qe Security "/q:*[System[(Level=1  or Level=2 or Level=3)]]" /f:text /rd:true /c:1
wevtutil qe Setup "/q:*[System[(Level=1  or Level=2 or Level=3)]]" /f:text /rd:true /c:1
wevtutil qe System "/q:*[System[(Level=1  or Level=2 or Level=3)]]" /f:text /rd:true /c:1
wevtutil qe ForwardedEvents "/q:*[System[(Level=1  or Level=2 or Level=3)]]" /f:text /rd:true /c:1
```

### Google Chrome portable 64 bit

1. http://portableapps.com/apps/internet/google_chrome_portable / **64 bit**
1. Extract with 7-Zip File Manager
1. `find "DownloadURL=" App\AppInfo\installer.ini`
1. `wget %DownloadURL%`
1. `7za e *_chrome_installer.exe`
1. `7za x chrome.7z`

### Virtualize Windows applications

- http://www.cameyo.com/ (Windows Server)
- https://www.rollapp.com/ (Ubuntu)
- https://turbo.net/ (WINE)

### /usr/bin on Windows

Create folder and prepend to PATH

Prepend: `%SystemDrive%\usr\bin;`

```batch
mkdir %SystemDrive%\usr\bin
SystemPropertiesAdvanced.exe
```

### Wget

Binary: https://eternallybored.org/misc/wget/

Mozilla CA certificate store: https://curl.haxx.se/ca/cacert.pem

##### CA download

```batch
:: Download deb package from https://packages.debian.org/stable/all/ca-certificates/download
7za e -t# "./ca-certificates_*_all.deb" "4.xz"
7za e "4.xz"
7za e -o.\bundle "4" ".\usr\share\ca-certificates\mozilla\*.crt"
type ".\bundle\*.crt" > "C:\usr\bin\ca-certificates.crt"
del /Q "ca-certificates_*_all.deb" "4.xz" "4" "bundle"
```

```ini
## C:\usr\bin\.wgetrc

ca-certificate = C:/usr/bin/ca-certificates.crt
content-disposition = on
#default: ca-certificate = c:/ssl/ssl/cert.pem
#http_proxy = http://192.168.2.161:8080/
#server_response = on
#verbose = on
```

##### Replace Microsoft CA certificates

```bash
wget -nv -O- https://curl.haxx.se/ca/cacert.pem \
    | csplit --suppress-matched --elide-empty-files --silent -f "ca-" -b "%03d.crt" - '/^$/' '{*}'
rm -f ca-000.crt
unix2dos *.crt
```

```batch
:: Certificates / Computer account
mmc

FOR %%C IN (ca*.crt) DO (
    certutil -addstore "Root" "%%C"
    IF ERRORLEVEL 1 PAUSE
)
```

### OpenSSL

https://indy.fulgan.com/SSL/ ZIP: `openssl-*-x64_86-win64.zip` `C:\usr\openssl\`

`echo CAfile = C:/usr/bin/cacert.pem> C:\usr\openssl\openssl.cnf`

### KeePass

Binary: http://keepass.info/download.html `C:\usr\keepass\`

Tools / Options / Security / Enter Master Key on Secure Desktop `cacls auth-data.kdbx /P PC\User:F`

Tools / Options / Advanced tab / Automatically save database on exit and workspace locking

Tools / Options / Integration tab / URL overrides...

- lftp: `cmd://cmd.exe /C "echo lftp -e 'set ftp:ssl-allow 0;' -u '{USERNAME},{PASSWORD}' ftp://{BASE:HOST} && pause"`
- sshp: `cmd://putty.exe -ssh -P {BASE:PORT} {USERNAME}@{BASE:RMVSCM}`
- rdp:  `cmd://mstsc.exe /v:{BASE:RMVSCM}`

#### Plugins

`C:\usr\keepass\Plugins\`

- [KeeAgent](http://lechnology.com/software/keeagent/#download) (SSH agent)
- [KeeOtp](https://bitbucket.org/devinmartin/keeotp/downloads) (TOTP 2FA)
- [Readable Passphrase Generator](https://readablepassphrase.codeplex.com/releases) (XKCD-style passwords)
- * [IOProtocolExt](http://keepass.info/plugins.html#ioprotocolext) (SCP, SFTP, FTPS)
- * [KeeCloud](https://bitbucket.org/devinmartin/keecloud/downloads) (S3, Azure Blob, Dropbox)

#### QR code reader with webcam

[bcWebCam](http://www.bcwebcam.de/en/index.html) .NET

### Putty

```batch
cd \usr\bin
wget -nv -N http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe
wget -nv -N http://the.earth.li/~sgtatham/putty/latest/x86/pscp.exe
wget -nv -N http://the.earth.li/~sgtatham/putty/latest/x86/puttygen.exe
wget -nv -N https://github.com/altercation/solarized/raw/master/putty-colors-solarized/solarized_dark.reg
wget -nv -N https://github.com/altercation/solarized/raw/master/putty-colors-solarized/solarized_light.reg
```

Alternatives

- https://puttytray.goeswhere.com/ PuTTYtray
- http://www.fosshub.com/KiTTY.html (Cygterm)
- http://www.extraputty.com/download.php
- https://github.com/Maximus5/ConEmu/releases

### Firefox Developer Edition

See: [ff-dev](./ff-dev/)

[Flash player](http://www.adobe.com/hu/products/flashplayer/distribution3.html)

Bookmarks for Launchy: `browser.bookmarks.autoExportHTML = true`

Fullscreen screenshot: Shift + F2 `screenshot --fullpage --clipboard`

Web Developer extension: https://addons.mozilla.org/en-US/firefox/addon/web-developer/

### Keypirinha

`Profile\User\Keypirinha.ini`

```ini
[app]
launch_at_startup = yes
hotkey_run = Alt+F1

[gui]
always_on_top = yes
hide_on_focus_lost = immediate
retain_last_search = yes
escape_always_closes = yes
show_on_taskbar = no
show_scores = no
show_history_hits = no
```

### Virtualization

- Hyper-V: enable in BIOS, `bcdedit /set hypervisorlaunchtype Auto` , `virtmgmt.msc`
- [VMware Workstation Player](https://www.vmware.com/products/player/playerpro-evaluation.html)
- [VirtualBox installer](https://www.virtualbox.org/wiki/Downloads)

### Desktop malware cleaning

- [herdProtect](http://www.herdprotect.com/downloads.aspx) (Portable)
- [HitmanPro.Alert](http://www.surfright.nl/en/alert) Second opinion behavioral based Anti-Malware, [beta](http://www.wilderssecurity.com/threads/hitmanpro-alert-support-and-discussion-thread.324841/page-307)

- [NoVirusThanks tools](http://www.novirusthanks.org/)
- [AdwCleaner](https://toolslib.net/downloads/viewdownload/1-adwcleaner/)
- [Malwarebytes Anti-Malware](https://www.malwarebytes.org/antimalware/)
- [Zemana AntiMalware](https://zemana.com/en-US/Download)
- [Bitdefender Adware Removal Tool](http://www.bitdefender.com/solutions/adware-removal-tool-for-pc.html)
- [Bulk Crap Uninstaller](http://klocmansoftware.weebly.com/) [BCUninstaller source](https://github.com/Klocman/Bulk-Crap-Uninstaller)

- [Malwarebytes Anti-Rootkit Beta](https://www.malwarebytes.com/antirootkit/)
- [Kaspersky TDSSKiller](https://usa.kaspersky.com/downloads/TDSSKiller)
- https://www.sophos.com/products/free-tools/sophos-anti-rootkit.aspx

### Cygwin

#### Create vdisk in `diskpart`

```
rem In cmd.exe:  mkdir C:\cygwin2

create vdisk file="e:\cygwin64.vhd" maximum=20000
attach vdisk
create partition primary
assign mount="C:\cygwin2"
format label="Cygwin2" quick
```

#### [Cygwin 64 bit setup](https://cygwin.com/setup-x86_64.exe)

```diskpart
:: Cygwin vdisk script --- cyg-disk.dpt ---

select vdisk file="e:\cygwin64.vhd"
attach vdisk

rem select vdisk file="e:\cygwin64.vhd"
rem detach vdisk
```

```batch
:: Mount Cygwin vdisk --- cygpart-mount.cmd ---
@diskpart /s "C:\usr\bin\cyg-disk.dpt"
```

#### Shortcut target

```batch
:: Start Cygwin terminal
C:\cygwin2\bin\mintty.exe -i /Cygwin-Terminal.ico -
```

#### Associate .dpt extension

```batch
ftype DiskPartScript=diskpart.exe /s %1
assoc .dpt=DiskPartScript
```

#### Install apt-cyg

```bash
wget -nv -P /usr/local/sbin "https://github.com/transcode-open/apt-cyg/raw/master/apt-cyg"
chmod +x /usr/local/sbin/apt-cyg
```

#### Cygwin/X (XWin)

- `xorg-server`
- `xinit`

Application example: `fontforge`

Connect to remote X11: `cygwin$ ssh -CXY user@example.com`

## Backup steps

1. Run `backup-workstation.cmd` on Windows shutdown
1. Have [hubiC client](https://hubic.com/en/downloads) back it up daily, keep 10 versions

## Remove unused drivers @yearly

```batch
set "DEVMGR_SHOW_NONPRESENT_DEVICES=1"
devmgmt.msc
:: View / Show hidden devices
```

## Computer shops

- http://www.mindenolcso.hu/hasznalt-szamitogep.html
- http://www.mindenolcso.hu/hasznalt-monitor.html
- http://www.marseus.hu/hu/memoria/szerver/
- http://microstore.hu/index.php?manufacturer_id[]=503&path=20_94&route=product%2Fcategory
