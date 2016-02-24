#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.


# update
sudo apt-get update

# install Ruby and mailcatcher
sudo apt-get -y install ruby ruby-dev
sudo gem install mailcatcher


## show versions
echo 'Homestead Box' \
&& echo "\n" \
&& php -v | sed -n 1p \
&& mysql --version \
&& psql --version \
&& nginx -v  2>&1 | grep version \
&& redis-cli info server | grep redis_version \
&& ruby -v \
&& echo 'node' `node -v` \
&& echo 'npm' `npm -v` \
&& mailcatcher --version > homestead.box.txt

cat homestead.box.txt

