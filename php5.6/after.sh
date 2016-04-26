#!/bin/bash

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.

echo "export LOGS_DIR='/home/vagrant/lmo-homestead-boxes/logs/php56'" /etc/profile.d/homestead.sh

mkdir -p $LOGS_DIR

LOCK=$LOGS_DIR/.installed

set -e

if [ -e $LOCK ]; then
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

    # Fix EE group by
    printf '%s\n%s\n%s\n' '[mysqld]' '# Fix EE issues with group by' 'sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' > /etc/mysql/conf.d/sql_mode.cnf
    service mysql restart 

    ## Install phpMyAdmin
    composer -g config repositories.phpmyadmin composer https://www.phpmyadmin.net/packages.json
    composer create-project phpmyadmin/phpmyadmin --no-dev
    cp /home/vagrant/lmo-homestead-boxes/config.ini.php /home/vagrant/phpmyadmin/config.ini.php
    ln -s /home/vagrant/phpmyadmin/ /home/vagrant/lmo-homestead-boxes/phpmyadmin

    touch $LOCK

fi

## Save LAN IP
LAN_IP=$(/sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ":" $3 }' |awk -F: '{ if ( $1 == "eth2" ) { print $2 } }');
echo $LAN_IP > /home/vagrant/lmo-homestead-boxes/.php5.6-ip


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

