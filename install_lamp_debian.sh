# Apache
apt-get install apache2 apache2-doc apache2-utils libexpat1 ssl-cert -y

# PHP and Modules
apt-get install libapache2-mod-php5 php5 php5-common php5-curl php5-dev php5-gd php5-idn php-pear php5-imagick php5-mcrypt php5-mysql php5-ps php5-pspell php5-recode php5-xsl -y

# MySQL
# will prompt for password
apt-get install mysql-server mysql-client -y

# PHPMyAdmin
# will prompt for password
apt-get install phpmyadmin -y

# Permissions
chown -R www-data:www-data /var/www

# Enable mod_rewrite
a2enmod rewrite

# Restart Apache
service apache2 restart
