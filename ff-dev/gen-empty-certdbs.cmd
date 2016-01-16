7za x -y .\firefox-*.exe "core\"
start /WAIT core\firefox.exe -no-remote -profile empty-certdbs\
:: Quit Firefox!
bin\certutil.exe -L -d empty-certdbs\
wget -nv -O szepenet.pem http://ca.szepe.net/pem
bin\certutil.exe -A -i szepenet.pem -n szepenet -t "C,," -d empty-certdbs\
bin\certutil.exe -L -d empty-certdbs\
copy /Y empty-certdbs\cert8.db szepenet-cert8.db
copy /Y empty-certdbs\key3.db szepenet-key3.db
copy /Y empty-certdbs\secmod.db szepenet-secmod.db
rmdir /Q /S empty-certdbs\
