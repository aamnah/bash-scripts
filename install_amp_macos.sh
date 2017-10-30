#!/bin/bash

###############################################################################
#
# AUTHOR: Aamnah
# LINK: http://aamnah.com
# DESCRIPTION: Install Apache, MySQL and PHP on macOS High Sierra
# VERSION: 0.5
# REFERENCE 1: https://getgrav.org/blog/macos-sierra-apache-multiple-php-versions
# REFERENCE 2: https://praxent.com/blog/native-lamp-stack-mac-os-x
#
###############################################################################

# This script
# - Installs Homebrew if not installed
# - Installs XCode Command Line Tools if not installed
# - Installs Apache with Homebrew
# - Creates ~/Sites directory if not exists
# - Confgiures Apache conf file using sed
# - Confgiures Apache Virtual Hosts
# - Installs PHP with Homebrew
# - Confgiures PHP conf file using sed
# - Installs MariaDB with Homebrew
# - Installs Sequel-Pro with Homebrew Cask
# - Installs Dnsmasq with Homebrew and configures it


# TODO
# - [ ] Test the script 
# - [ ] Make a copy of conf files before editing them
# - [ ] Try the Include directive to include a new file with your settings instead of directly editing the main conf files - 
#       e.g. `Include /Users/aamnah/Sites/*.conf` - will include all .conf files in the Site folders in the main httpd.conf
#       (more: http://httpd.apache.org/docs/current/mod/core.html#include)
#       https://gist.github.com/vitorbritto/4fea3514fa09ef298b1f
# - [ ] If not using Include, append our changes to the end of the file instead of editing settings in place. The later ones will override the ones that came before
# - [ ] Move conf files to the Sites folder for easy access
# - [x] Add logs folder inside Sites directory

# LINKS
# - [1]: http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html#toc8
# - [2]: https://stackoverflow.com/a/18220301/890814 (If statements syntax [] vs [[]])
# - [3]: https://unix.stackexchange.com/a/132512 (Caprturing error messages)

# Color Reset
Color_Off='\033[0m'       # Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan



# SCRIPT VARIABLES
SITES_DIR="/Users/$(whoami)/Sites"
LOGS_DIR="${SITES_DIR}/logs"
BREW_APACHE_CONF_FILE="/usr/local/etc/httpd/httpd.conf"
BREW_VHOSTS_CONF_FILE="/usr/local/etc/httpd/extra/httpd-vhosts.conf"
BREW_PHP_CONF_FILE="/usr/local/etc/php/7.0/php.ini" # for v7.0
BREW_DNSMASQ_CONF_FILE="/usr/local/etc/dnsmasq.conf"


install_Homebrew() {
# Check if Homebrew is installed, install if we don't have it, update if we do

	if [[ $(command -v brew) == "" ]]; then 
		echo -e "\n ${Cyan} Installing Homebrew .. ${Color_Off}"
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
		echo -e "\n ${Cyan} Updating Homebrew, this may take a while .. ${Color_Off}"
		brew update
		echo -e "\n ${Cyan} Running brew doctor .. ${Color_Off}"
		brew doctor
	fi
}


install_XCode() {
# Install XCode's Command Line Tools

	error_installed="xcode-select: error: command line tools are already installed, use \"Software Update\" to install updates"

	if [[ $(xcode-select --install 2>&1) == ${error_installed} ]]; then # 2>&1 is redirecting the stderr to stdout so we don't see it in prompt Link[3]
		echo -e "\n ${Cyan} Command Line Tools are already installed .. ${Color_Off}"
	else
		echo -e "\n ${Cyan} Installing XCode Command Line Tools .. ${Color_Off}"
		echo -e "\n ${Cyan} You'll be prompted for the Install. This will take some time.. 
						 \n  Come back and continue once you're done installing ${Color_Off}"
		xcode-select --install
	
		# stop code execution and prompt for continuation
		# OR exit and re-run the script?
	fi

	# More on determining if command line tools are installed
	# https://stackoverflow.com/questions/15371925/how-to-check-if-command-line-tools-is-installed
	# Since i have already installed them, it's hard for me to know the difference in versions
	# or test the script for the purpose of detecting if they're installed
}

create_SitesFolder() {
# Create ~/Sites folder if it doesn't already exist + add a demo index.html

	if [ -d ${SITES_DIR} ]; then
		echo -e "\n ${Yellow} ${SITES_DIR} directory already exists, skipping .. ${Color_Off}"
	else
		echo -e "\n ${Cyan} Creating ${SITES_DIR} directory .. ${Color_Off}"
		mkdir ${SITES_DIR}
		mkdir ${LOGS_DIR} # create a folder for logs too, this will be referenced by httpd.conf/https-vhosts.conf
		echo -e "<h1>Apache works!</h1> \n <p>Hello from <strong>${SITES_DIR}</strong></p>" > ${SITES_DIR}/index.html
	fi
}


install_Apache() {
# Install Apache and set it to auto-start on boot

	echo -e "\n ${Cyan} Stopping built-in Apache .. ${Color_Off}"
	sudo apachectl stop

	echo -e "\n ${Cyan} Removing any auto-loading scripts for built-in Apache .. ${Color_Off}"
	sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null

	echo -e "\n ${Cyan} Installing Apache via Homebrew .. ${Color_Off}"
	brew install httpd

	echo -e "\n ${Cyan} Auto start the new Apache server .. ${Color_Off}"
	sudo brew services start httpd
	
	# TROUBLESHOOTING
	# sudo apachectl configtest
	# sudo apachectl -S # verify Virtual hosts
	# sudo apachectl start
	# sudo apachectl stop
	# sudo apachectl -k restart
	# tail -f /usr/local/var/log/httpd/error_log
}


configure_Apache() {
# Edit ${BREW_APACHE_CONF_FILE} to change settings like Port, DirectoryRoot, AllowOverride, mod_rewrite etc.

	# PORT
	echo -e "\n ${Cyan} Updating Apache localhost PORT from 8080 to 80 .. ${Color_Off}"
	sed -i '' 's/Listen 8080/Listen 80/' ${BREW_APACHE_CONF_FILE}
	
	# DirectoryRoot
	echo -e "\n ${Cyan} Updating DirectoryRoot to Users/$(whoami)/Sites .. ${Color_Off}"
		# more on how to use a variable in a sed command
		# https://stackoverflow.com/a/19152051/890814
	sed -i '' "s|DocumentRoot \"/usr/local/var/www\"|DocumentRoot \"/Users/$(whoami)/Sites\"|" ${BREW_APACHE_CONF_FILE}
	sed -i '' "s|<Directory \"/usr/local/var/www\">|<Directory \"/Users/$(whoami)/Sites\">|" ${BREW_APACHE_CONF_FILE}
	
	# AllowOverride All
	echo -e "\n ${Cyan} Setting AllowOverride All .. ${Color_Off}"
	sed -i '' 's|AllowOverride None|AllowOverride All|' ${BREW_APACHE_CONF_FILE}
	
	# mod_rewrite
	echo -e "\n ${Cyan} Enabling mod_rewrite .. ${Color_Off}"
	sed -i '' "s|#LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so|LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so|" ${BREW_APACHE_CONF_FILE}
	
	# User and Group
	echo -e "\n ${Cyan} Setting User and Group .. ${Color_Off}"
	sed -i '' "s|User _www|User $(whoami)|" ${BREW_APACHE_CONF_FILE}
	sed -i '' "s|Group _www|Group staff|" ${BREW_APACHE_CONF_FILE}
	
	# ServerName
	echo -e "\n ${Cyan} Setting ServerName .. ${Color_Off}"
	sed -i '' "s|	#ServerName www.example.com:8080|ServerName localhost|" ${BREW_APACHE_CONF_FILE}

	echo -e "\n ${Cyan} Running a configuration check .. ${Color_Off}"
	sudo apachectl configtest

	# Restart Apache so the configurtaion takes effect
	echo -e "\n ${Cyan} Restarting Apache"
	sudo apachectl -k restart # The -k will force a restart immediately
}


configure_VirtualHosts() {
# Enable mod_vhost_alias.so and Edit ${BREW_VHOSTS_CONF_FILE}

	# Enable Virtual Hosts
	echo -e "\n ${Cyan} Enabling Virtual Hosts .. ${Color_Off}"
	sed -i '' "s|#LoadModule vhost_alias_module lib/httpd/modules/mod_vhost_alias.so|LoadModule vhost_alias_module lib/httpd/modules/mod_vhost_alias.so|" ${BREW_APACHE_CONF_FILE}
	sed -i '' "s|#Include /usr/local/etc/httpd/extra/httpd-vhosts.conf|Include /usr/local/etc/httpd/extra/httpd-vhosts.conf|" ${BREW_APACHE_CONF_FILE}
	

	# edit vhosts.conf ${BREW_VHOSTS_CONF_FILE}
	# echo -e "\n ${Cyan} Creating custom httpd-vhosts.conf in ${SITES_DIR} .. ${Color_Off}"
	
	echo -e "


<VirtualHost *:80>
    DocumentRoot "${SITES_DIR}"
    ServerName localhost
    ErrorLog "${LOGS_DIR}/error_log"
</VirtualHost>

<VirtualHost *:80>
    DocumentRoot "${SITES_DIR}/demoDevSite"
    ServerName demoDevSite.dev
    ErrorLog "${LOGS_DIR}/dev-error_log"
</VirtualHost>" >> ${BREW_VHOSTS_CONF_FILE}


# 	# Link to our custom vhosts file
# 	echo -e "
# # Load Custom Virtual Hosts Configuration file in ${SITES_DIR}
# Include /Users/$(whoami)/Sites/httpd-vhosts.conf" >> ${BREW_APACHE_CONF_FILE}

	# Verify config
	echo -e "\n ${Cyan} Verifying Virtual Hosts .. ${Color_Off}"
	apachectl -S
	
	# Restart Apache so the configurtaion takes effect
	echo -e "\n ${Cyan} Restarting Apache .. ${Color_Off}"
	sudo apachectl -k restart # The -k will force a restart immediately
}


install_PHP() {
# Install PHP 7.0
	
	echo -e "\n ${Cyan} Adding Homebrew Tap for PHP .. ${Color_Off}"
	brew tap homebrew/php
	brew update

	echo -e "\n ${Cyan} Installing PHP 7.0 .. ${Color_Off}"
	brew install php70 --with-httpd 

	# You must reinstall each PHP version with reinstall command rather than install 
	# if you have previously installed PHP through Brew
}

####################### TESTED TILL HERE #######################


configure_PHP() { 
# Configure PHP to load modules from generic paths and validate install with phpinfo()

	# A common thing to change is the memory setting, or the date.timezone configuration
	
	# replace specific version paths with some more generic paths
	sed -i '' "s|LoadModule php7_module        /usr/local/Cellar/php70/7.0.24_16/libexec/apache2/libphp7.so|LoadModule php7_module    /usr/local/opt/php70/libexec/apache2/libphp7.so|" ${BREW_PHP_CONF_FILE}
	
	# Validate install
	echo "<?php phpinfo();" > ~/Sites/info.php
	echo "Test PHP at: http://localhost/info.php"
}


install_MariaDB() { # TESTED
# Install MariaDB as a drop-in replacement for MySQL as it is easily installed and updated with Brew
	echo -e "\n ${Cyan} Updating Homebrew .. ${Color_Off}"
	brew update
	
	echo -e "\n ${Cyan} Installing MariaDB .. ${Color_Off}"
	brew install mariadb
	
	echo -e "\n ${Cyan} Setting MariaDB to Auto-start on boot .. ${Color_Off}"
	brew services start mariadb

	# /usr/local/bin/mysql_secure_installation

	# login with: mysql -u root
}


install_SequelPro() { # TESTED
# Install Sequel Pro with Homebrew Cask

	# make sure Homebrew Cask is available
	brew tap caskroom/cask

	# install Sequel Pro
	echo -e "\n ${Cyan} Installing Sequel Pro .. ${Color_Off}"
	brew cask install sequel-pro

	# You should be able to use Sequel Pro to connect to MariaDB via the Socket option using user 'root'
	# mysql -u root
}

install_Dnsmasq() { # TESTED
# install and configure Dnsmasq to automatically handle wildcard *.dev names and forward all of them to localhost (127.0.0.1)
	brew install dnsmasq
	
	echo -e "\n ${Cyan} Setting up *.dev hosts .. ${Color_Off}"
	echo 'address=/.dev/127.0.0.1' > ${BREW_DNSMASQ_CONF_FILE} 
	
	echo -e "\n ${Cyan} Auto-starting Dnsmasq .. ${Color_Off}"
	sudo brew services start dnsmasq
	
	echo -e "\n ${Cyan} Adding Dnsmasq to resolvers .. ${Color_Off}"
	sudo mkdir -v /etc/resolver
	sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'
	
	echo -e "\n ${Cyan} Testing by pinging a bogus .dev address .. ${Color_Off}"
	ping -c 3 bogus.dev
}



# RUN
install_Homebrew
install_XCode
create_SitesFolder
install_Apache
configure_Apache
configure_VirtualHosts
install_PHP
configure_PHP
install_MariaDB
install_SequelPro
install_Dnsmasq
