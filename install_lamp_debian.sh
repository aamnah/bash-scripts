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
apt update -y

# Apache
apt install apache2 apache2-doc apache2-utils libexpat1 ssl-cert -y
# check Apache configuration: apachectl configtest

# PHP and Modules

# PHP5 on Ubuntu 14.04 LTS
# apt install php5 libapache2-mod-php5 php5-cli php5-common php5-curl php5-dev php5-gd php5-intl php5-mcrypt php5-mysql php5-recode php5-xml php5-pspell php5-ps php5-imagick php-pear php-gettext -y

# PHP5 on Ubuntu 17.04 Zesty
# sudo add-apt-repository ppa:ondrej/php
# sudo apt update
# apt install php5.6 libapache2-mod-php5.6 php5.6-cli php5.6-common php-curl php5.6-curl php5.6-dev php5.6-gd php5.6-intl php5.6-mcrypt php5.6-mbstring php5.6-mysql php5.6-recode php5.6-xml php5.6-pspell php5.6-ps php5.6-imagick php-pear php-gettext -y

# PHP7
# apt install php php7.1-common php-curl php7.1-curl php7.1-dev php7.1-gd php7.1-intl php7.1-mcrypt php7.1-mbstring php7.1-mysql php7.1-pspell php7.1-recode php7.1-xml php-imagick php-pear php-gettext -y
apt install php php-common php-curl php-dev php-gd php-gettext php-imagick php-intl php-mbstring php-mcrypt php-mysql php-pear php-pspell php-recode php-xml -y

# MySQL
# will prompt for password
apt install mysql-server mysql-client -y

# secure MySQL install
mysql_secure_installation

# PHPMyAdmin
# will prompt for password
apt install phpmyadmin -y

# Permissions
chown -R www-data:www-data /var/www

# Enable mod_rewrite, required for WordPress permalinks and .htaccess files
a2enmod rewrite
# php5enmod mcrypt # PHP5 on Ubuntu 14.04 LTS
# phpenmod -v 5.6 mcrypt mbstring # PHP5 on Ubuntu 17.04
phpenmod -v 7.1 mcrypt mbstring # PHP7

# Restart Apache
service apache2 restart
