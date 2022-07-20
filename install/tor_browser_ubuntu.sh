#!/bin/bash

# Install Tor Browser from the command line
# Author: Aamnah <hello@aamnah.com>
# https://github.com/aamnah/bash-scripts/blob/master/install/tor_browser_ubuntu.sh

VERSION='11.5' # <-- update this to match latest version, update rest of the variables only if needed
ARCHITECTURE='64'
LANG='en-US'

PACKAGE="tor-browser-linux${ARCHITECTURE}-${VERSION}_${LANG}.tar.xz"
SIGNATURE="tor-browser-linux${ARCHITECTURE}-${VERSION}_${LANG}.tar.xz.asc"
GPG_KEY='./tor-browser.keyring'
DOWNLOAD_LOCATION=$(dirname "$*")
EXTRACTED_FOLDER_NAME="tor-browser_${LANG}"
INSTALL_DIR='/opt'
INSTALL_PATH="/opt/${EXTRACTED_FOLDER_NAME}"

# Download package
# First, go to the Tor download page and download the Tor Browser installer file and run the following commands to install it. https://www.torproject.org/download/
# You'll get a link like this:
# https://www.torproject.org/dist/torbrowser/11.5/tor-browser-linux64-11.5_en-US.tar.xz 
echo -e "\n Downloading package .. \n"
wget -O ${PACKAGE} https://www.torproject.org/dist/torbrowser/${VERSION}/tor-browser-linux${ARCHITECTURE}-${VERSION}_${LANG}.tar.xz 


# Download signature
echo -e "\n Downloading signature .. \n"
# wget https://www.torproject.org/dist/torbrowser/11.5/tor-browser-linux64-11.5_en-US.tar.xz.asc 
wget -O ${SIGNATURE} https://www.torproject.org/dist/torbrowser/${VERSION}/tor-browser-linux${ARCHITECTURE}-${VERSION}_${LANG}.tar.xz.asc


# Import GPG key and Verify package with signature 

echo -e "\n Verifying signature .. \n"
gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org # import key
gpg --output ${GPG_KEY} --export 0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290 # save key to file
gpgv --keyring ${GPG_KEY} ${SIGNATURE} ${PACKAGE} # verify the signature of package using key


# Extract to install location
echo -e "\n Extracting and moving to install location: ${INSTALL_DIR} .. \n"
tar -xvf ${PACKAGE} # gives a folder like: tr-browser_en-US
sudo mv ${EXTRACTED_FOLDER_NAME} ${INSTALL_DIR}


echo -e "\n Cleaning up .. \n"
rm -rf ${DOWNLOAD_LOCATION}/${GPG_KEY}
rm -rf ${DOWNLOAD_LOCATION}/${PACKAGE}
rm -rf ${DOWNLOAD_LOCATION}/${SIGNATURE}

# Starting and adding desktop shortcut
echo -e "\n Making executable and adding desktop shortcut .. \n"
sudo chmod +x ${INSTALL_PATH}/start-tor-browser.desktop
cd ${INSTALL_PATH}
./start-tor-browser.desktop --register-app

echo -e "\n DONE .. \n"
