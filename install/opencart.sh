#!/bin/bash

###################################################################
#         Author: Aamnah Akram
#           Link: http://github.com/aamnah/bash-scripts
#    Description: Bash script to install Opencart
#          Usage: You can use 'curl' to run this script directly from Github.
# curl -L https://raw.githubusercontent.com/aamnah/bash-scripts/master/install/opencart.sh | bash
#                 Run the script from the directory you want to install opencart in
###################################################################



# TODO
# [x] File and folder permissions for install https://gist.github.com/aamnah/9cab2942f42d5fe7035d
# [x] File and folder permissions post-install (secure) https://gist.github.com/aamnah/eff1c13f8b8d893c7c61
# [x] Delete install folder when done
# [ ] Create the config files from script instead of going to http://domain.com/install and entering them

# COLORS
Cyan='\033[0;36m'         # Cyan
Green='\033[0;32m'        # Green
Red='\033[0;31m'          # Red
BCyan='\033[1;36m'        # Bold Cyan
Color_Off='\033[0m'       # Text Reset

checkVersion() {
	# check if version provided is a valid OpenCart release
	version_list=("3.0.2.0" "3.0.1.2" "3.0.1.1" "3.0.0.0" "2.3.0.2" "2.3.0.1" "2.3.0.0" "2.2.0.0" "2.1.0.2" "2.1.0.1" "2.0.3.1" "2.0.2.0" "2.0.1.1" "2.0.1.0" "2.0.0.0" "1.5.6.4" "1.5.6.3" "1.5.6.2" "1.5.6.1" "1.5.6")

	match=0
	for v in "${version_list[@]}"
	do
		if [[ $v = "$VERSION" ]]; then
			match=1
			break
		fi
	done
}

setInstallPermissions() {
	# Set install permissions for files and folders
	chmod 777 config.php
	chmod 777 admin/config.php
	chmod -R 777 image/
	chmod -R 777 image/cache/
	chmod -R 777 image/catalog/
	chmod -R 777 system/storage/cache/
	chmod -R 777 system/storage/logs/
	chmod -R 777 system/storage/download/
	chmod -R 777 system/storage/upload/
	chmod -R 777 system/storage/modification/
}

secureInstallation() {
	# delete install folder
	if [ -d "install/" ]; then
		echo -e "${Cyan} Deleting install/ folder.. ${Color_Off}"
		rm -rf install
	fi

	# To change all the directories to 755 (-rwxr-xr-x)
	echo -e "${Cyan} Setting permissions for all directories to 755.. ${Color_Off}"
	find . -type d -exec chmod 755 {} \;

	# To change all the files to 644 (-rw-r--r--):
	echo -e "${Cyan} Setting permissions for all files to 644.. ${Color_Off}"
	find . -type f -exec chmod 644 {} \;

	# set 444 for admin files
	echo -e "${Cyan} Setting secure 444 permissions for admin files.. ${Color_Off}"	
	chmod 444 config.php
	chmod 444 admin/config.php
	chmod 444 index.php
	chmod 444 admin/index.php
	chmod 444 system/startup.php

	# set 777 for cache
	echo -e "${Cyan} Setting 777 permissions for cache folders.. ${Color_Off}"	
	chmod 777 image/cache/
	chmod 777 system/storage/cache/
}

installOpenCart() {
	# Download files for that version from Github
	echo -e "${Cyan} Downloading files.. ${Color_Off}"
	wget -O opencart-$VERSION.zip https://github.com/opencart/opencart/archive/${VERSION}.tar.gz

	echo -e "${Cyan} Extracting.. ${Color_Off}"
	tar xzf opencart-$VERSION.zip
	
	echo -e "${Cyan} Cleaning up.. ${Color_Off}"
	mv opencart-$VERSION/* .
	rm -rf opencart-$VERSION.zip opencart-$VERSION # delete downloaded source files
	mv upload/* . # move all files out of the uploads folder to current dir
	mv upload/.htaccess.txt ./.htaccess # move and rename .htaccess
	rm -rf upload # delete the now empty upload dir
	rm -rf install.txt license.txt # delete unnecessary files
	cp config-dist.php config.php # rename config files
	cp admin/config-dist.php admin/config.php
	
	# Set install permissions for files and folders
	setInstallPermissions

	echo -e "${Cyan} Opencart was successfully copied. Please run the install script to finish installation. \n
 http://yourdomain.com/install \n ${Color_Off}"
	return 1
}

# Ask for version
echo -ne "${Cyan} What version should i install? (for example: ${BCyan}1.5.6.4${Cyan} or ${BCyan}3.0.2.0${Cyan})${Color_Off}"
read VERSION

checkVersion

if [[ $match = 0 ]]; then
	echo -e "${Red} Not a valid OpenCart version. Exiting.. ${Color_Off}"
	return 0
fi

if [[ $match = 1 ]]; then
	installOpenCart
fi

echo -ne "${Cyan}Do you want to secure the installation? (yes/no) ${Color_Off} \n (You should only secure the installation after you are done with the installation process)"
read SECURE

if [ "${SECURE}" = "yes" ]; then
	secureInstallation
	echo -e "${Green}\n ALL DONE! Enjoy.. \n ${Color_Off}"
else
	echo -e "${Green}\n ALL DONE! Enjoy.. \n ${Color_Off}"
fi
