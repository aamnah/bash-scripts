apt-get update -y

# Apache
apt-get install apache2 apache2-doc apache2-utils libexpat1 ssl-cert -y
# check Apache configuration: apachectl configtest

# PHP and Modules
# PHP5
# apt-get install php5 libapache2-mod-php5 php7.0-cli php5-common php5-curl php5-dev php5-gd php5-intl php5-mcrypt php5-mysql  php5-recode php5-xsl php5-pspell php5-ps php5-imagick php-pear -y

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

# Enable mod_rewrite
a2enmod rewrite

# Restart Apache
service apache2 restart
