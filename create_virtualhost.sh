
#!/bin/bash

###################################################################
#         Author: Aamnah Akram
#           Link: http://github.com/aamnah/bash-scripts
#    Description: Sets up a domain for hosting
#            Run: bash ceate_virtualhost.sh mydomain.com
###################################################################

COLOR_CYAN='\033[0;36m'   # Cyan
COLOR_GREEN='\033[0;32m'  # Green
COLOR_BGREEN='\033[1;32m' # Bold Green
COLOR_RED='\033[0;31m'    # Red
COLOR_OFF='\033[0m'       # Color Reset

# create dir
echo -e "\n${COLOR_CYAN}Creating public_html directory .. ${COLOR_OFF}"
mkdir -p /var/www/$1/public_html

# grant perms
# sets the user running the script as owner
echo -e "\n${COLOR_CYAN}Setting Permissions .. ${COLOR_OFF}"
sudo chown -R $USER:$USER /var/www/$1/public_html

# set perms
chmod -R 755 /var/www

# demo pages
echo -e "\n${COLOR_CYAN}Creating an index.html demo page .. ${COLOR_OFF}"
touch /var/www/$1/public_html/index.html

echo -e "\n${COLOR_CYAN}<html>
  <head>
    <title>Welcome to $1!</title>
  </head>
  <body>
    <h1>Success! The $1 virtual host is working!</h1>
  </body>
</html>
" >> /var/www/$1/public_html/index.html

# create virtual host file
echo -e "\n${COLOR_CYAN}Creating virtual host file for the domain $1 .. ${COLOR_OFF}"
touch /etc/apache2/sites-available/$1.conf
echo -e "<VirtualHost *:80>
    ServerAdmin admin@$1
    ServerName $1
    ServerAlias www.$1
    DocumentRoot /var/www/$1/public_html/
    
    # .htaccess
    <Directory /var/www/$1/public_html/>
      Options Indexes FollowSymLinks
      AllowOverride All
    </Directory>
    
    # Logs
    ErrorLog /var/www/$1/logs/error.log
    CustomLog /var/www/$1/logs/access.log combined
    
    # Custom php.ini path
    # PHPINIDir /var/www/$1/public_html/
</VirtualHost>" > /etc/apache2/sites-available/$1.conf

#enable new virtual host file
echo -e "\n${COLOR_CYAN}Enabling new host file .. ${COLOR_OFF}"
a2ensite $1.conf

#disable default virtual host
echo -e "\n${COLOR_CYAN}Disabling default virtual host .. ${COLOR_OFF}"
a2dissite 000-default.conf

# restart apache
echo -e "\n${COLOR_CYAN}Restarting Apache .. ${COLOR_OFF}"
service apache2 restart

echo -e "\n${COLOR_GREEN}$1 has been successfully set up! ${COLOR_OFF}"
