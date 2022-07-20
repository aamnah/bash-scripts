#!/bin/bash

# Install Tor Project from official project's source repo
# Run this script with sudo
# Author: Aamnah <hello@aamnah.com>
# https://github.com/aamnah/bash-scripts/blob/master/install/tor_project_ubuntu.sh

GPG_KEY='/usr/share/keyrings/tor-archive-keyring.gpg'

# Add repo
echo -e "\n Adding Tor project repo .. \n"
touch /etc/apt/sources.list.d/tor.list

echo -e "
deb     [arch=$(dpkg --print-architecture) signed-by=${GPG_KEY}] https://deb.torproject.org/torproject.org $(lsb_release -c | cut -f2) main
deb-src [arch=$(dpkg --print-architecture) signed-by=${GPG_KEY}] https://deb.torproject.org/torproject.org $(lsb_release -c | cut -f2) main
" >> /etc/apt/sources.list.d/tor.list


# Add gpg key used to sign the packages
echo -e "\n Adding GPG key to sign the packages with .. \n"
wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee ${GPG_KEY} >/dev/null

# Install
echo -e "\n Installing .. \n"
apt update
apt install apt-transport-https
apt install tor deb.torproject.org-keyring

# Update config
echo -e "\n Updating Tor config .. \n"
sed -i 's/#ControlPort 9051/ControlPort 9051/g' /etc/tor/torrc
sed -i 's/#CookieAuthentication 1/CookieAuthentication 0/g' /etc/tor/torrc

sudo /etc/init.d/tor restart

echo -e "\n DONE .. \n"

