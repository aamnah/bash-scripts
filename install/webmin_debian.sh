#!/bin/bash

# Install Webmin on Debian

# add the Webmin repository to `sources.list`
sudo echo "
# Webmin
deb http://download.webmin.com/download/repository sarge contrib
" >> /etc/apt/sources.list

# add Webmin GPG key to apt, so the source repo will be trusted
wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -

sudo apt update
sudo apt install apt-transport-https -y
sudo apt install webmin -y

# Add UFW Firewall Rule for Webmin port
# sudo ufw allow 10000/tcp
sudo ufw allow webmin

# default port: 10000
# default login: the server login of the user who installed
# https://server_IP_address:10000
