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

    # install Ruby and mailcatcher
    sudo apt-get -y install ruby ruby-dev
    sudo gem install mailcatcher

    touch /.installed

fi


## show versions
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
echo '----------'
