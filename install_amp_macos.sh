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
# - Installs XCode if not installed
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
# - [ ] Add logs folder inside Sites directory

# LINKS
# - http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html#toc8


SITES_FOLDER="/Users/$(whoami)/Sites"
BREW_APACHE_CONF_FILE="/usr/local/etc/httpd/httpd.conf"
BREW_VHOSTS_CONF_FILE="/usr/local/etc/httpd/extra/httpd-vhosts.conf"
BREW_PHP_CONF_FILE="/usr/local/etc/php/7.0/php.ini" # for v7.0
BREW_DNSMASQ_CONF_FILE="/usr/local/etc/dnsmasq.conf"


install_Homebrew() {
# Check if Homebrew is installed, install if we don't have it, update if we do

	if [[ $(command -v brew) == "" ]]; then 
		echo "Installing Homebrew.. "
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
		echo "Updating Homebrew.. "
		brew update
		brew doctor
		
		echo "Adding Homebrew Tap for PHP.. "
		brew tap homebrew/php
		brew update
	fi
}


install_XCode() {
# Check if XCode is installed, install if we don't have it

	if [[ $(command -v xcode-select) == "" ]]; then 
		echo "Installing XCode.. "
		xcode-select --install
	fi
}


create_SitesFolder() {
# Create ~/Sites folder if it doesn't already exists

	if [ -d ${SITES_FOLDER} ]; then
		echo -e "${SITES_FOLDER} directory already exists, skipping.."
	else
		echo -e "Creating ${SITES_FOLDER} directory"
		mkdir ${SITES_FOLDER}
		echo -e "<h1>Apache works!</h1> \n <p>Hello from <strong>${SITES_FOLDER}</strong></p>" > ${SITES_FOLDER}/index.html
	fi
}


install_Apache() {
# Install Apache and set it to auto-start on boot

	echo "Stopping built-in Apache.. "
	sudo apachectl stop

	echo "Removing any auto-loading scripts.. "
	sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null

	echo "Installing Apache via Homebrew"
	brew install httpd

	echo "Auto start the new Apache server"
	sudo brew services start httpd
	
	# TROUBLESHOOTING
	# sudo apachectl configtest
	# sudo apachectl -S  
	# sudo apachectl start
	# sudo apachectl stop
	# sudo apachectl -k restart
	# tail -f /usr/local/var/log/httpd/error_log
}


configure_Apache() {
# Edit ${BREW_APACHE_CONF_FILE} to change settings like Port, DirectoryRoot, AllowOverride, mod_rewrite etc.

	# PORT
	echo "Updating Apache localhost PORT from 8080 to 80 .. "
	sed -i '' 's/Listen 8080/Listen 80/' ${BREW_APACHE_CONF_FILE}
	
	# DirectoryRoot
	echo -e "Updating DirectoryRoot to Users/${whoami}/Sites .."
		# more on how to use a variable in a sed command
		# https://stackoverflow.com/a/19152051/890814
	sed -i '' "s|DocumentRoot \"/usr/local/var/www\"|DocumentRoot \"/Users/${whoami}/Sites\"|" ${BREW_APACHE_CONF_FILE}
	sed -i '' "s|<Directory \"/usr/local/var/www\">|<Directory \"/Users/${whoami}/Sites\">|" ${BREW_APACHE_CONF_FILE}
	
	# AllowOverride All
	echo 'Setting AllowOverride All'
	sed -i '' 's|AllowOverride None|AllowOverride All|' ${BREW_APACHE_CONF_FILE}
	
	# mod_rewrite
	echo "Enabling mod_rewrite .. "
	sed -i '' "s|#LoadModule rewrite_module libexec/apache2/mod_rewrite.so|LoadModule rewrite_module libexec/apache2/mod_rewrite.so|" ${BREW_APACHE_CONF_FILE}
	
	# User and Group
	echo "Setting User and Group .. "
	sed -i '' "s|User _www|User ${whoami}|" ${BREW_APACHE_CONF_FILE}
	sed -i '' "s|Group _www|Group staff|" ${BREW_APACHE_CONF_FILE}
	
	# ServerName
	echo "Setting ServerName .. "
	sed -i '' "s|#ServerName www.example.com:80|ServerName localhost|" ${BREW_APACHE_CONF_FILE}

	echo "Running a configuration check .. "
	sudo apachectl configtest

	# Restart Apache so the configurtaion takes effect
	echo "Restarting Apache"
	sudo apachectl -k restart # The -k will force a restart immediately
}


configure_VirtualHosts() {
# Enable mod_vhost_alias.so and Edit ${BREW_VHOSTS_CONF_FILE}

	# Enable Virtual Hosts
	sed -i '' "s|#LoadModule vhost_alias_module libexec/apache2/mod_vhost_alias.so|LoadModule vhost_alias_module libexec/apache2/mod_vhost_alias.so|" ${BREW_APACHE_CONF_FILE}
	sed -i '' "s|#Include /private/etc/apache2/extra/httpd-vhosts.conf|Include /private/etc/apache2/extra/httpd-vhosts.conf|" ${BREW_APACHE_CONF_FILE}
	
	# edit vhosts.conf ${BREW_VHOSTS_CONF_FILE}
	
	# Restart Apache so the configurtaion takes effect
	echo "Restarting Apache"
	sudo apachectl -k restart # The -k will force a restart immediately
}


install_PHP() {
# Install PHP 7.0

	echo "Install PHP 7.0"
	brew install php70 --with-httpd # You must reinstall each PHP version with reinstall command rather than install if you have 
	# previously installed PHP through Brew
}


configure_PHP() { 
# Configure PHP to load modules from generic paths and validate install with phpinfo()

	# A common thing to change is the memory setting, or the date.timezone configuration
	
	# replace specific version paths with some more generic paths
	sed -i '' "s|LoadModule php7_module        /usr/local/Cellar/php70/7.0.24_16/libexec/apache2/libphp7.so|LoadModule php7_module    /usr/local/opt/php70/libexec/apache2/libphp7.so|" ${BREW_PHP_CONF_FILE}
	
	# Validate install
	echo "<?php phpinfo();" > ~/Sites/info.php
	echo "Test PHP at: http://localhost/info.php"
}


install_MariaDB() {
# Install MariaDB as a drop-in replacement for MySQL as it is easily installed and updated with Brew
	echo "Updating Homebrew .. "
	brew update
	
	echo "Installing MariaDB .. "
	brew install mariadb
	
	echo "Setting MariaDB to Auto-start on boot"
	brew services start mariadb

	# /usr/local/bin/mysql_secure_installation
	# login with: mysql -u root
}


install_SequelPro() {
# Install Sequel Pro with Homebrew Cask

	# install Homebrew Cask
	brew install caskroom/cask/brew-cask

	# install Sequel Pro
	brew cask install sequel-pro

	# You should be able to automatically create a new connection to MariaSB via the Socket option without changing any settings
}


install_Dnsmasq() {
# install and configure Dnsmasq to automatically handle wildcard *.dev names and forward all of them to localhost (127.0.0.1)
	brew install dnsmasq
	
	echo "Setting up *.dev hosts"
	echo 'address=/.dev/127.0.0.1' > ${BREW_DNSMASQ_CONF_FILE} 
	
	echo "Auto-starting Dnsmasq"
	sudo brew services start dnsmasq
	
	echo "Adding Dnsmasq to resolvers"
	sudo mkdir -v /etc/resolver
	sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'
	
	echo "Testing by pinging a bogus .dev name"
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
