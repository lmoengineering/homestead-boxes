# homestead-boxes

Run multiple homestead boxes globally for all files


## Install


__Requirements__

- PHP >= 5.5.9
- composer
- ssh public key added to vim.beanstalkapp.com and github.com account

### 1. Clone Repo
clone repo using git into local folder (example ~/lmo-homestead-boxes)

    git clone git@github.com:lmoengineering/homestead-boxes.git ~/lmo-homestead-boxes

### 2. Install Dependencies

Using composer install all needed dependencies
    
    cd ~/lmo-homestead-boxes
    composer install

### 3. Add Aliases

Copy the code below into __.profile__ or __.bashrc__ or __.zshrc__

    source $HOME/lmo-homestead-boxes/homestead-alias

### 4. Setup each box 

within each folder copy Homestead.yaml.sample to Homstead.yaml and update settings

    cd ~/lmo-homestead-boxes/php7
    cp Homestead.yaml.sample Homstead.yaml
    composer install

change any settings as needed in the yaml file

    cd ~/lmo-homestead-boxes/php5.6
    cp Homestead.yaml.sample Homstead.yaml
    composer install

change any settings as needed in the yaml file

### 5. Import and Boot up

Create the base machines and provision both of them using the new aliases

    h7 up
    h5 up

### 6. Add domains to host file

you can get the current sites and hosts file info from either of these URLs if the boxes are running

[http://192.168.10.11/](http://192.168.10.11/)  
[http://192.168.10.10/](http://192.168.10.10/)  



## ToDo

- ~~Intergrate into php_hosts_manager for updating hosts file~~
- Add database dump commands
