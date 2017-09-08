#
# Update Android ca-certificates.
#

exit 0

# https://packages.debian.org/testing/all/ca-certificates/download
mkdir -p /root/ca/android
cd /root/ca/
wget http://ftp.de.debian.org/debian/pool/main/c/ca-certificates/ca-certificates_20170717_all.deb
ar x *.deb
tar -xf data.tar.*
cd usr/share/ca-certificates/mozilla/
# Comment out link_hash_cert()
mcedit /usr/bin/c_rehash:110
c_rehash -v .
# Remove comment
mcedit /usr/bin/c_rehash:110
ls -lGg | grep -F -- '->' | cut -c32- | sed -e 's|^\(\S*\) -> \(\S*\)$|mv \2 /root/ca/android/\1|' | bash
cd /root/ca/android/
tar -cf android.tar *


# Android: mount -o remount,rw /system
#          cd /system/etc/security/cacerts/
#          busybox tar -xf android.tar
#          mount -o remount,ro /system
