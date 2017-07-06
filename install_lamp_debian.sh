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
# apt-get install php5.6 libapache2-mod-php5.6 php5.6-cli php5.6-common php5.6-curl php5.6-dev php5.6-gd php5.6-intl php5.6-mcrypt php5.6-mysql  php5.6-recode php5.6-xsl php5.6-pspell php5.6-ps php5.6-imagick php-pear -y

# PHP7
apt-get install php7.0 libapache2-mod-php7.0 php7.0-cli php7.0-common php7.0-curl php7.0-dev php7.0-gd php7.0-intl php7.0-mcrypt php7.0-mysql php7.0-pspell php7.0-recode php7.0-xsl php-imagick php-pear -y

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
# sudo php5enmod mcrypt # PHP5
phpenmod -v 7.0 mcrypt # PHP7

# Restart Apache
service apache2 restart
