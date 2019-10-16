#!/bin/bash

uninstall_node () {
  echo -e "\n\n Removig existing Nodejs, if any .."
  # apt packages
  sudo apt purge --auto-remove nodejs npm
  
  # snap packages
  sudo snap remove node npm

  # remove node source from /etc/apt/sources.list.d
  sudo rm -rf /etc/apt/sources.list.d/nodesource.list
  sudo rm -rf /etc/apt/sources.list.d/nodesource.list.save

  # update
  sudo apt update
}

install_nvm () {
  echo -e "\n\n ----- Installing NVM (Node Version Manager) .."
  wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.35.0/install.sh | bash

  # make sure the source lines added to `~/.bashrc` are loaded in current terminal
  # otherwise the rest of the script will give a 'nvm: command not found' error
  # source ${HOME}/.bashrc

  # confirm nvm install
  # echo -e "\n\n ----- NVM $(nvm --version) is installed .. "

  # install the node versions
  # nvm install node # install Latest
  #nvm install --lts # install LTS version

  # select the version you want to use
  # nvm use node # use Latest
  # nvm use --lts # use LTS version

  # installing a version for the first time also uses and sets it as default

  # exit successfully
  #exit 0
}

# uninstall_node
install_nvm

echo -e "\n\n ----- NVM has been installed. run 'source ~/.bashrc' to use it right away. 

 ----- Use 'nvm install --lts' to install and use LTS version of Node"


# TODO
# CHECK IF NODE IS INSTALLED BEFORE TRYING TO REMOVE IT
# Check if the bash profile is called `.bashrc` (Ubuntu) or `.bash_profile` (macOS)
