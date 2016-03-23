#!/bin/sh

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
    sudo apt-get update

    # for db imports
    sudo apt-get install unzip

    # install Ruby and mailcatcher
    sudo apt-get -y install ruby ruby-dev
    sudo gem install mailcatcher

    echo 'description "Mailcatcher"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

exec /usr/bin/env $(which mailcatcher) --foreground --http-ip=0.0.0.0' > /etc/init/mailcatcher.conf
    service mailcatcher start

    touch /.installed

fi


## show versions
## show versions
echo ""
box-info
echo '----------'
int-ips
echo '----------'
