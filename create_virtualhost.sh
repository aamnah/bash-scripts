# create_virtualHosts
# derived from: https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-14-04-lts

# create dir
mkdir -p /var/www/$1/public_html

# grant perms
sudo chown -R $USER:$USER /var/www/$1/public_html

# set perms
chmod -R 755 /var/www

# demo pages
touch /var/www/$1/public_html/index.html

echo -e "<html>
  <head>
    <title>Welcome to $1!</title>
  </head>
  <body>
    <h1>Success! The $1 virtual host is working!</h1>
  </body>
</html>
" >> /var/www/$1/public_html/index.html

# create virtual host file
touch /etc/apache2/sites-available/$1.conf
echo -e "<VirtualHost *:80>
    ServerAdmin admin@$1
    ServerName $1
    ServerAlias www.$1
    DocumentRoot /var/www/$1/public_html/
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/$1.conf

# enable new virtual host file
a2ensite $1.conf

# disable default 
a2dissite 000-default.conf

# restart apache
service apache2 restart
