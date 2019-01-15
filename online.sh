#!/bin/bash
# I use /mnt/hgfs/files because that's where vmware workstation mounts a folder called files by default
# Change as necessary
fileDir="/mnt/hgfs/files"
echo "Make sure you run this sudoed or as root!"
sleep 2
echo "Waiting for dpkg unlock."
$fileDir/dpkg-check.sh #checks if there's an apt process already running and waits for it to finish
apt install -y dpkg-dev apt-rdepends apache2
mkdir -p /var/www/html/debs
cd /var/www/html/debs
Packages="python abe" #packages should be space seperated, no commas
echo "Waiting for dpkg unlock."
$fileDir/dpkg-check.sh
#add "| sed 's///g'" to replace virtual packages below
apt download $(apt-rdepends $Packages | grep "^\w" | sed 's/debconf-2.0/debconf/g' | sed 's/libjack-0.125/libjack0/g' | sed 's/libwayland-egl1$/libwayland-egl1-mesa/g')
dpkg-scanpackages /var/www/html/debs/ | gzip -9c > /var/www/html/debs/Packages.gz
#this redirect is necessary because of a bug in apt. see https://unix.stackexchange.com/questions/148303/apt-get-install-gives-404-not-found-but-url-works
echo "Redirect /debs//var/www/html/debs/ /debs/" >> /etc/apache2/apache2.conf
service apache2 restart
echo "Now network the vm's together and run offline.sh on the offline vm."
