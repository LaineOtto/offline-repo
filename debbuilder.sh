#!/bin/bash
echo "Make sure you run this sudoed or as root!"
homedir="/home/lotto" #edit to be your home dir
cd $homedir
apt install -y dh-make devscripts
scripts="helloworld.rb" #space seperated list of scripts to package. edit the 2nd heredoc below to change acceptable script names
scriptdir="aptscripts-0.1" #must be <pkg name>-<version #>
mkdir $scriptdir
cp $scripts $scriptdir
cd $scriptdir
cat  <<EOF >>~/.bashrc #edit these variables if you want your name/email
DEBEMAIL="person@company.tld"
DEBFULLNAME="Person McTester"
export DEBEMAIL DEBFULLNAME
EOF
. $homedir/.bashrc
dh_make --indep --createorig -y #arch independent, create a .orig.tar.xz, assume yes. creates debian subdirectory
touch $homedir/$scriptdir/debian/install
cat <<EOF >$homedir/$scriptdir/debian/install #one line per script, supports globbing. format "<script> <install location>"
#*.sh usr/bin #make sure to comment out any lines not in use, will error out otherwise
*.rb usr/bin
EOF
debuild -us -uc #build deb package without signing
cd $homedir
cp -f *deb /var/www/html/debs
dpkg-scanpackages /var/www/html/debs/ | gzip -9c > /var/www/html/debs/Packages.gz #update Packages.gz