#!/bin/bash

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

if [ -e /.installed ]; then
    echo 'Already installed.'

else
    echo ''
    echo 'INSTALLING'
    echo '----------'

    # update
    #rm /var/lib/apt/lists/* -vf
    apt-get clean
    apt-get update

    # for db imports
    apt-get install unzip

    ## intall rvm / ruby
    bash lmo-homestead-boxes/scripts/rvm.sh
    source /usr/local/rvm/scripts/rvm

    # install mailcatcher
    gem install mailcatcher

    echo 'description "Mailcatcher"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

exec /usr/bin/env $(which mailcatcher) --foreground --http-ip=0.0.0.0' > /etc/init/mailcatcher.conf
    service mailcatcher start

    touch /.installed

fi

## Save LAN IP
LAN_IP=$(/sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ":" $3 }' |awk -F: '{ if ( $1 == "eth2" ) { print $2 } }');
echo $LAN_IP > /home/vagrant/lmo-homestead-boxes/.php7-ip


## show versions & IPs
echo ""
    echo 'BOX INFO' 
    php -v | sed -n 1p 
    mysql --version 
    psql --version 
    nginx -v  2>&1 | grep version 
    redis-cli info server | grep redis_version 
    ruby -v     
    echo 'node' `node -v` 
    echo 'npm' `npm -v` 
    mailcatcher --version 
    echo '----------';
