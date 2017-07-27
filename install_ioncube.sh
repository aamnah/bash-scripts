#!/bin/bash

###################################################################
#         Author: Aamnah Akram
#           Link: http://github.com/aamnah/bash-scripts
#    Description: Installs ionCube loader on a Debain Ubuntu system
#            Run: bash install_ioncube.sh
###################################################################

# Color Reset
Color_Off='\033[0m'       # Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan


PHP_VERSION=`php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;"` # 7.2
PHP_EXT_DIR=`php -i | grep extension_dir | cut -d ">" -f3 | cut -d " " -f2` # /usr/lib/php/20160731, using cut to get only the folder path from output
# PHP_INI_DIR=`php -i | grep "Scan this dir for additional .ini files" | cut -d ">" -f2 | cut -d " " -f2` # /etc/php/7.2/cli/conf.d
PHP_INI_DIR="/etc/php/${PHP_VERSION}/apache2/conf.d" # double-quotes are important to evaluate ${PHP_VERSION}
PHP_MODS_DIR="/etc/php/${PHP_VERSION}/mods-available" # /etc/php/7.2/mods-available/

# NOTE: You may run into issues with ${PHP_VERSION} if ionCube hasn't provided the module for the PHP version you have installed. 
# For example, module for PHP 7.2 is not available at the moment. 
# In that case, manually copy the module for the closest matching PHP version

# TEST
echo -e "\n${Cyan}ARCH: `arch`"
echo -e "PHP_VERSION: ${PHP_VERSION}"
echo -e "PHP_EXT_DIR: ${PHP_EXT_DIR}"
echo -e "PHP_INI_DIR: ${PHP_INI_DIR}"
echo -e "PHP_MODS_DIR: ${PHP_MODS_DIR}"
echo -e "FILE_LINK: ${FILE_LINK} ${Color_Off}"

getFiles() {
	# Download and extract source files
	echo -e "\n ${Cyan}Downloading and extracting files ${Color_Off}"

	# download the files for the right architecture 32-bit or 64-bit
	if [ `arch` == "i686" ]; then
		wget -O ioncube_loaders.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86.tar.gz
	elif [ `arch` == "x86_64" ]; then
		wget -O ioncube_loaders.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
	fi

	tar -xzf ioncube_loaders.zip
}

copyModule() {
	# Copy ioncube loader to the PHP extensions directory
	echo -e "\n ${Cyan}Copying module to PHP extensions directory ${Color_Off}"

	# TODO
	# check if file exists
	# if not, show an error stating no module file for that version,
	# you can manually copy the closest matching PHP version to this directory ${PHP_INI_DIR}
	# exit

	# check if module is provided
	if [ ! -e ioncube/ioncube_loader_lin_${PHP_VERSION}.so ]; then
		echo -e "\n ${Yellow}ionCube module doesn't exist for the PHP version (${PHP_VERSION}) installed on your system"
		echo -e "\n You can manually copy the closest matching PHP version to this directory ${PHP_EXT_DIR} ${Color_Off}"
		echo -e "\n ${Red}EXIT ${Color_Off}"
		# exit 1

	# check if module is already in extensions directory
	elif [ -e ${PHP_EXT_DIR}/ioncube_loader_lin_${PHP_VERSION}.so ]; then
	  echo -e "\n ${Yellow}File already exists! Skipping..  ${Color_Off}"

	# copy the module to extensions directory
	else
  	sudo cp ioncube/ioncube_loader_lin_${PHP_VERSION}.so ${PHP_EXT_DIR}
		# ${PHP_VERSION} may cause issues if the file isn't provided by ionCube for that version. e.g. 7.2 isn't provided atm
		# sudo cp ioncube/ioncube_loader_lin_7.0.so ${PHP_EXT_DIR}
	fi


}

loadModule() {
	# load ionCube module by adding it to .ini files directory
	echo -e "\n ${Cyan}Loading the module ${Color_Off}"

	# create .ini file in mods-available dir
	touch ${PHP_MODS_DIR}/ioncube.ini
	echo -e "zend_extension = \"${PHP_EXT_DIR}/ioncube_loader_lin_${PHP_VERSION}.so\"" > ${PHP_MODS_DIR}/ioncube.ini
	
	# TODO 
	# check if a symbolic link already exists
	# if [ condition ]; then
	#   # do something
	# else
	#   # do something else
	# fi
	# create a link to that file from the additional .ini files directory
	# ln -s target linkName
	ln -s ${PHP_MODS_DIR}/ioncube.ini ${PHP_INI_DIR}/00-ioncube.ini # The 00 at the beginning of the filename ensures this file will be loaded before other PHP conf files.
}

testInstall() {
	echo -e "\n ${Cyan}Testing install.. ${Color_Off}"
	php -r "echo var_export(extension_loaded('ionCube Loader') ,true);"
}

cleanup() {
	echo -e "\n ${Cyan}Cleaning up.. ${Color_Off}"
	rm -rf ioncube_loaders_lin_x86-64.tar.gz
	rm -rf ioncube
}

getFiles
copyModule
loadModule
testInstall
cleanup

echo -e "\n ${Cyan}Restarting Apache ${Color_Off}"
service apache2 restart

echo -e "\n ${Green}SUCCESS ${Color_Off}"

# ISSUES
# - [ ] `php -i` gives directory paths for 'cli' instaed of 'apache2', /etc/php/7.2/cli/conf.d instead of /etc/php/7.2/apache2/conf.d
# - [ ] `arch` gives 'i686' for 32-bit while the download link uses 'x86'
# - [ ] ionCube loader may not have provided the module for your PHP version, for example 7.2. In cases like this ${PHP_VERSION} will evaluate but wont find any relevant files
