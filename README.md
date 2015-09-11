# Prepare my Windows 7 workstation

## Identification

- Name: HP Z210 Convertible Minitower Base Model Workstation
- Model #: XM856AV
- Serial #: CZC13941PV

## Backup steps

1. Run `backup-workstation.cmd` on shutdown
1. Have [hubiC client](https://hubic.com/en/downloads) backup daily, don't keep previous versions

### Boot display

[BCDEdit /set reference](https://msdn.microsoft.com/en-us/library/windows/hardware/ff542202%28v=vs.85%29.aspx)

```batch
bcdedit /set quietboot on
bcdedit /set sos on
```

Hardware related

- [CPUZ](http://www.cpuid.com/softwares/cpu-z.html)
- [HWMonitor](http://www.cpuid.com/softwares/hwmonitor.html)
- [S.M.A.R.T. status viewer](http://www.passmark.com/products/diskcheckup.htm)
- [Intel® Driver Update Utility.](http://www.intel.com/p/en_US/support/detect)
- [HP Support Assistant](http://www8.hp.com/us/en/campaigns/hpsupportassistant/hpsupport.html)

### Applications

- http://www.7-zip.org/download.html
- [CCleaner](http://mirror.szepe.net/software/)
- http://mattmahoney.net/dc/zpaq.html
- https://hubic.com/en/downloads
- http://www.launchy.net/download.php#windows
- https://github.com/Netrics/putty-launchy-plugin/releases
- http://sourceforge.net/projects/tasky-launchy/files/
- http://www.majorgeeks.com/files/details/hotkeyz.html

Also on http://mirror.szepe.net/software/

### /usr/local/bin on Windows

Create folder and prepend to PATH

```batch
mkdir %SystemDrive%\bin\utl
C:\Windows\System32\systempropertiesadvanced.exe
```

`%SystemDrive%\bin\utl;`

### wget

Binary: https://eternallybored.org/misc/wget/

CA: https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt
CA location: `C:/bin/utl/ca-bundle.crt`

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

### Firefox Develoer Edition

See: [ff-dev](./ff-dev/)
[Flash player](http://www.adobe.com/hu/products/flashplayer/distribution3.html)

### Virtualazation

[VirtualBox installer](https://www.virtualbox.org/wiki/Downloads)
[VMware Workstation Player](https://www.vmware.com/products/player/playerpro-evaluation.html)




### Cygwin

[setup-x86_64.exe](https://cygwin.com/setup-x86_64.exe)


