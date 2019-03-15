#!/bin/bash

###################################################################
#      Author: Aamnah Akram
#        Link: http://github.com/aamnah/bash-scripts
# Description: this script installs [todo.txt](http://todotxt.com/) 
#              in the default Dropbox folder on a Mac
###################################################################

# Color Reset
Color_Off='\033[0m'       # Text Reset
# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Cyan='\033[0;36m'         # Cyan

# response
msg_download() { 
	echo -e "\n ${Cyan}Downloading .. ${Color_Off}" 
}
msg_cleanup() { 
	echo -e "\n ${Cyan}Cleaning up .. ${Color_Off}" 
}
msg_executable() { 
	echo -e " ${Cyan}Making executable .. ${Color_Off}" 
}
msg_tweaks() { 
	echo -e " ${Cyan}Updating ~/.bash_profile ${Color_Off}" 
}
msg_success() { 
	echo -e "\n ${Green}todo.txt has been installed ${Color_Off}" 
}
msg_exists() { 
	echo -e "\n ${Red} A folder called 'todo' already exists. Abort. ${Color_Off}" 
}

# download
get() {
	msg_download
	cd ~/Dropbox
	wget https://github.com/ginatrapani/todo.txt-cli/archive/master.zip #C1
	unzip master.zip
}

cleanup() {
	msg_cleanup
	mv todo.txt-cli-master todo # rename extracted folder
	cd todo
	rm -rf LICENSE GEN-VERSION-FILE CONTRIBUTING.md Makefile README.textile tests/ # delete unnecessary files
}

makeExecutable() {
	msg_executable	
	chmod +x todo.sh
}

# add tweaks to .bash_profile
tweaks() { 
	msg_tweaks
	echo -e "

### todo.txt
PATH=$PATH:\"$HOME/Dropbox/todo\" #path
alias t='$HOME/Dropbox/todo/todo.sh -d $HOME/Dropbox/todo/todo.cfg' #alias
source $HOME/Dropbox/todo/todo_completion #auto-completion
complete -F _todo t #auto-completion for alias
export TODOTXT_DEFAULT_ACTION=ls #default action 
export TODOTXT_SORT_COMMAND='env LC_COLLATE=C sort -k 2,2 -k 1,1n' #sort by priority, then by number 
" >> ~/.bash_profile
}

# RUN
if [ -d "$HOME/Dropbox/todo" ]; then
	msg_exists
	exit
else
	get
	cleanup
	makeExecutable
	tweaks
	msg_success
fi

# Comments
##########
#C1: i used wget here becuase curl wasn't working. wget is NOT installed by default on a Mac. You can `brew install wget` though.
