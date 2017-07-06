#!/bin/bash

###################################################################
#         Author: Aamnah Akram
#           Link: http://github.com/aamnah/bash-scripts
#    Description: Installs an AMP stack and PHPMyAdmin plus tweaks. For Debian based systems.
#            Run: bash install_lamp_debian.sh
#          Notes: In case of any errors (e.g. MySQL) just re-run the script. 
#                 Nothing will be re-installed except for the packages with errors.
###################################################################

# Update system repos
apt-get update -y

# Apache
apt-get install apache2 apache2-doc apache2-utils libexpat1 ssl-cert -y
# check Apache configuration: apachectl configtest

# PHP and Modules
# PHP5
# apt-get install php5.6 libapache2-mod-php5.6 php5.6-cli php5.6-common php5.6-curl php5.6-dev php5.6-gd php5.6-intl php5.6-mcrypt php5.6-mbstring php5.6-mysql  php5.6-recode php5.6-xsl php5.6-pspell php5.6-ps php5.6-imagick php-pear php-gettext -y

# PHP7
apt-get install php php7.1-common php7.1-curl php7.1-dev php7.1-gd php7.1-intl php7.1-mcrypt php7.1-mbstring php7.1-mysql php7.1-pspell php7.1-recode php7.1-xsl php-imagick php-pear php-gettext -y

# MySQL
# will prompt for password
apt-get install mysql-server mysql-client -y

# secure MySQL install
mysql_secure_installation

# PHPMyAdmin
# will prompt for password
apt-get install phpmyadmin -y

# Permissions
chown -R www-data:www-data /var/www

# Enable mod_rewrite, required for WordPress permalinks and .htaccess files
a2enmod rewrite
# phpenmod -v 5.6 mcrypt mbstring # PHP5
phpenmod -v 7.0 mcrypt mbstring # PHP7

# Restart Apache
service apache2 restart
