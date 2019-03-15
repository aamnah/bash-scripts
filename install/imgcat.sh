#!/bin/bash

# Download and Save imgcat script
wget https://raw.githubusercontent.com/gnachman/iTerm2/master/tests/imgcat -O imgcat.sh 

# make script executable
chmod +x imgcat.sh

# move the script to a folder that is in $PATH to be able to call the script globally
sudo mv imgcat.sh /usr/local/bin/

# add an alias for calling script
echo "alias img='imgcat.sh'" >> ~/.bashrc

# relaod bash profile
source ~/.bashrc