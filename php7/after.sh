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
## show versions
echo ""
box-info
echo '----------'
int-ips
echo '----------'
