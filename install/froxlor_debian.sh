#!/bin/bash

###################################################################
#         Author: Aamnah Akram
#           Link: http://github.com/aamnah/bash-scripts
#    Description: this script installs [Froxlor](https://froxlor.org/) 
#                 on a Debian system (tested on Ubuntu 16.04).
# Pre-requisites: LAMP 
###################################################################

COLOR_CYAN='\033[0;36m'   # Cyan
COLOR_GREEN='\033[0;32m'  # Green
COLOR_BGREEN='\033[1;32m' # Bold Green
COLOR_RED='\033[0;31m'    # Red
COLOR_OFF='\033[0m'       # Color Reset
SERVER_IP=`dig +short myip.opendns.com @resolver1.opendns.com` # External IP of the server
MSG_SUCCESS='Froxlor has been successfully installed on this system.'


# add the repo
echo -e "\n${COLOR_CYAN}Adding Froxlor repository.. ${COLOR_OFF}"
touch /etc/apt/sources.list.d/froxlor.list
echo 'deb http://debian.froxlor.org jessie main' > /etc/apt/sources.list.d/froxlor.list

# approve key for Froxlor packages
echo -e "\n${COLOR_CYAN}Adding Froxlor approve key.. ${COLOR_OFF}"
apt-key adv --keyserver pool.sks-keyservers.net --recv-key FD88018B6F2D5390D051343FF6B4A8704F9E9BBC

# update system
echo -e "\n${COLOR_CYAN}Updating system.. ${COLOR_OFF}"
sudo apt-get update && apt-get upgrade -y

# install
echo -e "\n${COLOR_CYAN}Installing Froxlor.. ${COLOR_OFF}"
sudo apt-get install froxlor

# Debian Jessie - disable 000-default.conf vhost as it points to /var/www/html
# Because froxlor is being installed to /var/www/ you need to either adjust the default vhost config file
# (000-default.conf) to point to /var/www/ instead of /var/www/html/

# Permissions
echo -e "\n${COLOR_CYAN}Setting directory permissions.. ${COLOR_OFF}"
sudo chown -R www-data:www-data /var/www/froxlor/

# Web install
echo -e "\n${COLOR_CYAN}${MSG_SUCCESS} ${COLOR_OFF}"
echo -e "\n${COLOR_GREEN}Please continue with the web install: ${COLOR_BGREEN}http://${SERVER_IP}/froxlor ${COLOR_OFF}"
