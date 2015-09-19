# Prepare my Windows 7 workstation

## Identification

- Name: HP Z210 Convertible Minitower Base Model Workstation
- Model #: XM856AV
- Serial #: CZC13941PV

# Windows 10 "Light"

```batch
:: Remove all built-in Apps
???

:: Remove OneDrive
reg ADD "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f
taskkill /f /im OneDrive.exe
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
rd "%UserProfile%\OneDrive" /Q /S
rd "%LocalAppData%\Microsoft\OneDrive" /Q /S
rd "%ProgramData%\Microsoft OneDrive" /Q /S
rd "C:\OneDriveTemp" /Q /S
reg DELETE "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
reg DELETE "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f

:: Remove Defender
:: C:\Program Files\Windows Defender\MSASCui.exe
:: https://www.raymond.cc/blog/how-to-disable-uninstall-or-remove-windows-defender-in-vista/
"C:\Program Files\Windows Defender\mpcmdrun" -removedefinitions -all
reg ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /T REG_DWORD /d 0 /f
shutdown /t 0 /r
:: Reboot to KNOPPIX (F8-F8-F8)
`ntfs-3g.real /dev/sda1 /mnt && mv "/mnt/Program Files/Windows Defender" "/mnt/Program Files/_Windows Defender"`
:: Dummy file to prevent folder recreation
`touch "/mnt/Program Files/Windows Defender"`
:: @FIXME Remove services, drivers: WdFilter.sys, WdNisDrv.sys
:: sc delete WinDefend
:: sc delete WdNisSvc

:: Disable SSDP Discovery service (enumerates UPnP devices)
sc stop SSDPSRV
sc config SSDPSRV start= disabled

:: Disable Remote Registry service
sc stop RemoteRegistry
sc config RemoteRegistry start= disabled

:: Check missing files
Autoruns.exe
```

### Hardware related software

#### BIOS update

- [CPUZ](http://www.cpuid.com/softwares/cpu-z.html) Disable monitoring
- [HWMonitor](http://www.cpuid.com/softwares/hwmonitor.html)
- [S.M.A.R.T. status viewer](http://www.passmark.com/products/diskcheckup.htm)
- [Intel® Driver Update Utility.](http://www.intel.com/p/en_US/support/detect)
- [HP SoftPaq Download Manager](http://www8.hp.com/us/en/ads/clientmanagement/drivers-bios.html)
- [HP Support Assistant](http://www8.hp.com/us/en/campaigns/hpsupportassistant/hpsupport.html)
- [Fujitsu DeskUpdate](http://support.ts.fujitsu.com/DeskUpdate/)
- [Lenovo ThinkVantage System Update](https://support.lenovo.com/us/en/documents/tvsu-update)
- [NVIDIA QFE driver](http://www.nvidia.com/Download/Find.aspx?lang=en-us&QNF=1) (Quadro New Feature)

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
:: Choose what the power button does
:: Hibernate: shutdown /t 0 /f /h
```

#### Disble Windows key combinations

Not necessary.

```batch
reg ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWinKeys" /t REG_DWORD /d 1
```

#### Show known file extensions

```batch
reg ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f
```

#### Don't display delete confirmation

```batch
reg ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ConfirmFileDelete" /t REG_DWORD /d 0 /f
```

### Disable remote assistance (Terminal Server)

```batch
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 1 /f
```

#### Settings commands

```
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
* Security Center  wscui.cpl
* Firewall  Firewall.cpl
* Power Settings  powercfg.cpl
* Certificate Manager  certmgr.msc
* Mouse  main.cpl (Disable mouse shadow)
```

See also: http://ss64.com/nt/shell.html and `utl\shell-commands.cmd`

#### Fonts

- https://github.com/andreberg/Meslo-Font/releases (LGS=line gap small, DZ=dotted zero)
- http://www.fontsquirrel.com/fonts/open-sans

Usage in cmd.exe:

@FIXME `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont` `000`=`Meslo LG M DZ Regular`

#### Cursors

http://mercury21.deviantart.com/art/New-Mac-OS-X-Cursor-97810609

### Applications

- [7-zip 64](http://www.7-zip.org/download.html)
- [CCleaner 64](http://mirror.szepe.net/software/)
- [herdProtect](http://www.herdprotect.com/downloads.aspx) (Portable)
- [zpaq 64](http://mattmahoney.net/dc/zpaq.html)
- [hubiC client](https://hubic.com/en/downloads)
- [Launchy](http://www.launchy.net/download.php#windows)
    - https://github.com/Netrics/putty-launchy-plugin/releases
    - http://sourceforge.net/projects/tasky-launchy/files/
- [Total Commander 64](http://www.ghisler.com/amazons3.php)
- [IrfanView 64](http://www.irfanview.com/64bit.htm)
- [latest Skype.exe](http://mirror.szepe.net/software/Skype.exe)
- ??? Cyg-srv? [openssh](http://www.mls-software.com/opensshd.html)
- [Libre Office 64](https://www.libreoffice.org/download/libreoffice-fresh/?type=win-x86_64&lang=hu)
- [MuseScore 32](https://musescore.org/hu/let%C3%B6lt%C3%A9s)

Also on http://mirror.szepe.net/software/

### /usr/local/bin on Windows

Create folder and prepend to PATH

```batch
mkdir %SystemDrive%\bin\utl
SystemPropertiesAdvanced.exe
```

Prepend: `%SystemDrive%\bin\utl;`

### wget

Binary: https://eternallybored.org/misc/wget/

1. CA URL: https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt
1. CA file: `C:/bin/utl/ca-bundle.crt`

```ini
## C:\bin\utl\.wgetrc

ca-certificate = C:/bin/utl/ca-bundle.crt
content-disposition = on
#default: ca-certificate = c:/ssl/ssl/cert.pem
#http_proxy = http://192.168.2.161:8080/
#server_response = on
#verbose = on
```

### KeePass

Binary: http://keepass.info/download.html `c:\bin\keepass\`

#### Plugins

- http://lechnology.com/software/keeagent/#download `\plugin-KeeAgent\`
- https://readablepassphrase.codeplex.com/releases `\plugin-ReadablePassphrase\`
- http://keepass.info/plugins.html#ioprotocolext
- https://bitbucket.org/devinmartin/keecloud/downloads
- https://addons.mozilla.org/en-US/firefox/addon/keefox/

### Putty

```batch
wget -nv -N -P C:\bin\utl\ http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe
wget -nv -N -P C:\bin\utl\ http://the.earth.li/~sgtatham/putty/latest/x86/pscp.exe
wget -nv -N -P C:\bin\utl\ http://the.earth.li/~sgtatham/putty/latest/x86/puttygen.exe
wget -nv -N -P C:\bin\utl\ https://github.com/altercation/solarized/raw/master/putty-colors-solarized/solarized_dark.reg
wget -nv -N -P C:\bin\utl\ https://github.com/altercation/solarized/raw/master/putty-colors-solarized/solarized_light.reg
```

Alternatives

- http://www.fosshub.com/KiTTY.html (Cygterm)
- http://www.extraputty.com/download.php
- https://github.com/Maximus5/ConEmu/releases

### Firefox Developer Edition

See: [ff-dev](./ff-dev/)

[Flash player](http://www.adobe.com/hu/products/flashplayer/distribution3.html)

### Virtualization

Hyper-V `virtmgmt.msc` `bcdedit /set hypervisorlaunchtype Auto`
[VMware Workstation Player](https://www.vmware.com/products/player/playerpro-evaluation.html)
[VirtualBox installer](https://www.virtualbox.org/wiki/Downloads)

### Cygwin

#### [Cygwin 64 bit setup](https://cygwin.com/setup-x86_64.exe)

```batch
:: Mount Cygwin vdisk
@diskpart /s C:\bin\utl\cyg-disk.dpt
```

```
rem --- cyg-disk.dpt ---

select vdisk file="e:\cygwin64.vhd"
attach vdisk

rem select vdisk file="e:\cygwin64.vhd"
rem detach vdisk
```

#### Create vdisk in `diskpart`

```
rem In cmd.exe:  mkdir C:\cygwin2

create vdisk file="e:\cygwin64.vhd" maximum=20000
attach vdisk
create partition primary
assign mount="C:\cygwin2"
format label="Cygwin2" quick
```

#### Shortcut target

```batch
:: Start Cygwin terminal
C:\cygwin2\bin\mintty.exe -i /Cygwin-Terminal.ico -
```

#### Install apt-cyg

```bash
wget -nv -P /usr/local/sbin "https://github.com/transcode-open/apt-cyg/raw/master/apt-cyg"
chmod +x /usr/local/sbin/apt-cyg
```

## Backup steps

1. Run `backup-workstation.cmd` on Windows shutdown
1. Have [hubiC client](https://hubic.com/en/downloads) back it up daily, keep 10 versions

## Remove unused drivers yearly

```batch
set "DEVMGR_SHOW_NONPRESENT_DEVICES=1"
devmgmt.msc
:: View / Show hidden devices
```
