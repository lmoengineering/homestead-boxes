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
    apt-get clean
    apt-add-repository --yes ppa:brightbox/ruby-ng
    apt-get update

    # for db imports
    apt-get install unzip

    ## intall ruby2.3
    apt-get install --yes ruby2.3 ruby2.3-dev

    # install Ruby and mailcatcher
    gem install mailcatcher

    echo 'description "Mailcatcher"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

exec /usr/bin/env $(which mailcatcher) --foreground --http-ip=0.0.0.0' > /etc/init/mailcatcher.conf
    service mailcatcher start

    ## Install phpMyAdmin
    composer -g config repositories.phpmyadmin composer https://www.phpmyadmin.net/packages.json
    composer create-project phpmyadmin/phpmyadmin --no-dev
    cp /home/vagrant/homestead-boxes/config.ini.php /home/vagrant/phpmyadmin/config.ini.php
    ln -s /home/vagrant/phpmyadmin/ /home/vagrant/homestead-boxes/phpmyadmin

    touch /.installed

fi

## Save LAN IP
LAN_IP=$(/sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ":" $3 }' |awk -F: '{ if ( $1 == "eth2" ) { print $2 } }');
echo $LAN_IP > /home/vagrant/homestead-boxes/.php7-ip


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
