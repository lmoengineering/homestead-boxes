# homestead-boxes
multiple homestead boxes


## Install


__note PHP 5.5.9 required!!!__

### 1. Clone Repo
clone repo using git into local folder (example ~/lmo-homestead-boxes)

    git clone git@github.com:lmoengineering/homestead-boxes.git ~/lmo-homestead-boxes

### 2. Install Dependencies

Using composer install all needed dependencies

    composer install

### 3. Add Aliases

Copy the code below into __.profile__ or __.bashrc__ or __.zshrc__

    source $HOME/lmo-homestead-boxes/homestead-alias

### 4. Setup each box 

copy homestead.yaml.sample to homstead.yaml 
run composer install

### 6. Import and Boot up

Create the base machines and provision both of them using the new aliases

    h7 up
    h5 up

### 6. Add domains to host file

you can get the current sites and hosts file info from either of these URLs if the boxes are running

[http://192.168.10.11/](http://192.168.10.11/)  
[http://192.168.10.10/](http://192.168.10.10/)  


