#!/bin/bash

LAN_IP=$(/sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ":" $3 }' |awk -F: '{ if ( $1 == "eth2" || $1 == "enp0s9" ) { print $2 } }');

SITE=$1
#ADDR="$1.$LAN_IP.xip.io"
ADDR="$1.*" # wildcard should be enough to work from all IPs

echo "LAN IP: " $LAN_IP
echo "ADDR: " $ADDR

sudo bash -c "sed -i.bak 's/server_name $SITE;/server_name $SITE $ADDR;/' /etc/nginx/sites-available/$SITE"


