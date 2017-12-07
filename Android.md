### Applications

Create second **ext4** partition on external SD card with
[MiniTool Partition Wizard](https://www.partitionwizard.com/free-partition-manager.html)

- [KingoRoot](https://root-apk.kingoapp.com/)
- [Link2SD](https://play.google.com/store/apps/details?id=com.buak.Link2SD)
- [CCleaner](https://play.google.com/store/apps/details?id=com.piriform.ccleaner)
- [Vysor](https://chrome.google.com/webstore/detail/vysor/gidgenkbbabolejbgbpnhbimgjbffefm)
- [Root Certificate Manager](https://play.google.com/store/apps/details?id=net.jolivier.cert.Importer)

https://www.clockworkmod.com/

https://f-droid.org/

### Recovery

- [adb](https://wiki.lineageos.org/adb_fastboot_guide.html#on-windows)
- [TWRP](https://twrp.me/Devices/)
- [ClockWorkMod](https://theunlockr.com/2014/02/27/install-clockworkmod-recovery-samsung-galaxy-xcover-2-gt-s7710/)
- `dd if=/dev/block/mmcblk0p25 bs=1M of=/mnt/extp1/mmcblk0p25.img`

### ROMs

- [Samsung S7710XXANI3](https://www.sammobile.com/firmwares/galaxy-xcover2/GT-S7710/XEH/download/S7710XXANI3/39022/)
- [OmniROM](https://dl.omnirom.org/)
- [LineageOS](https://download.lineageos.org/)

Check your ROM CSC by dialling `*#1234#`

PDA represent your build version - `Build: GINGERBREAD.XXLA6` then PDA version of your ROM is XXLA6

### Synchronize contacts and calendar

@TODO Horde SyncML

### Battery

[Anker](https://www.anker.com/de/products/219/291/Zusatzakkus-mit-kolossaler-Kapazit%C3%A4t)

### Cross compile e2fsprogs

```bash
sudo apt-get install -y gcc-6-arm-linux-gnueabihf
git clone "http://git.kernel.org/?p=fs/ext2/e2fsprogs.git"
cd e2fsprogs/
mkdir ${HOME}/e2fsprogs/build
./configure --host=arm-unknown-linux-gnueabihf CC=arm-linux-gnueabihf-gcc-6 LDFLAGS=--static --prefix=${HOME}/e2fsprogs/build --disable-defrag
make install
file build/sbin/fsck.ext4
```
