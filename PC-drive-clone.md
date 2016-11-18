# Clone a PC's drive to another one

### On Windows

1. Check drice (C: right click)
1. Shrink partition (C:) to ~100 GB
1. Take a pendrivet (USB flash drive)
1. Copy *stable* release of [CloneZilla](http://clonezilla.org/downloads.php) by [Rufus](https://rufus.akeo.ie/) to the pendrive

Connect the new drive.
Boot up to Clonezilla on the pendrive.

### On Linux

```sh
sudo su -
cat /proc/partitions
# X=old drive  Y=new drive
dd if=dev/sdX of=/dev/sdY bs=512 count=64
blockdev --rereadpt /dev/sdY
cat /proc/partitions
ntfsclone -O /dev/sdY1 /dev/sdX1
ntfsclone -O /dev/sdY2 /dev/sdX2
halt -p
```
