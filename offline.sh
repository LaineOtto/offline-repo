#!/bin/bash
httpip="192.168.12.128" #set to the ip of the machine you ran online.sh on
echo "deb [trusted=yes arch=amd64] http://$httpip/debs/ /" > /etc/apt/sources.list.d/offline.list
rm -f /etc/apt/sources.list
apt update
echo "You can now apt."
