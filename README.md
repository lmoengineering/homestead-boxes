# homestead-boxes
multiple homestead boxes


## Install


0. Clone Repo

clone repo using git into local folder (example ~/lmo-homestead-boxes)

    git clone git@github.com:lmoengineering/homestead-boxes.git ~/lmo-homestead-boxes

0. Install Dependencies

Using composer install all needed dependencies

    composer install

0. Add Aliases

Copy the code below into __.profile__ or __.bashrc__ or __.zshrc__

    source $HOME/lmo-homestead-boxes/homestead-alias

0. Import and Boot up

Create the base machines and provision both of them using the new aliases

    h7 up
    h5 up

0. Add domains to host file

