#!/bin/bash

###################################################################
#         Author: Aamnah Akram
#           Link: http://github.com/aamnah/bash-scripts
#    Description: Sets up a domain for hosting
#            Run: bash setup_virtualhost.sh mydomain.com
###################################################################

# TO-DO
# DONE: exit if a domain is not provided
# DONE: exit if file/dir already exists
# DONE: check if Apache is installed
# DONE: take multiple domains as input
# set up hostnames `sudo nano /etc/hosts`
# install SSL with Lets Encrypt

# Color Reset
Color_Off='\033[0m'       # Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan


checkApacheInstall() {
  # Exit if Apache isn't installed
  APACHE=`find / -name apachectl`
  if [[ ${APACHE} = "" ]]; then
    echo -e "\n${Red}Apache is not installed, aborting.${Color_Off} You can install Apache with: ${Cyan}sudo apt-get install apache2${Color_Off} and try again"
    # sudo apt-get install apache2 apache2-utils ssl-cert libexpat1 -y
    exit 2
  fi
}

checkExistingConf() {
  # Exit if virtualhost conf file exists for the given domain
  PATH_CONF="/etc/apache2/sites-available/${DOMAIN}.conf"
  
  # check if file already exists and is not empty
  if [ -s "${PATH_CONF}" ]; then
    echo -e "\n${Red}${PATH_CONF} already EXISTS and is NOT EMPTY. Aborting ${Color_Off}"
    exit 3
  #check if file already exists
  elif [ -e "${PATH_CONF}" ]; then
    echo -e "\n${Yellow}${PATH_CONF} already EXISTS. Aborting ${Color_Off}"
    exit 3
  fi
}

checkExistingDir() {
  # Exit if a directory exits in /var/www for the given domain
  PATH_WWW="/var/www/${DOMAIN}"

  # check if directory already exists and is not empty
  if [ -d "${PATH_WWW}" ]; then
    echo -e "\n${Red}${PATH_WWW} already EXISTS. Aborting ${Color_Off}"
    exit 4
  fi 
}

showUsage() {
  echo -e "\nUsage: please provide a domain name (FQDN)"
}

disableDefault() {
  # Disable the default Apache virtual host
  echo -e "${Cyan}Disabling default virtual host .. ${Color_Off}"
  sudo a2dissite 000-default > /dev/null
}

enableSite() {
  # Enable site
  echo -e "${Cyan}Enabling ${DOMAIN} .. ${Color_Off}"
  sudo a2ensite ${DOMAIN}.conf > /dev/null
}

restartApache() {
  # Restart Apache
  echo -e "\n${Cyan}Restarting Apache .. ${Color_Off}"
  sudo service apache2 restart
}

createFiles() {
  # Make directories
  echo -e "\n${Cyan}Creating directory structure .. ${Color_Off}"
  mkdir -p /var/www/${DOMAIN}/public_html
  mkdir /var/www/${DOMAIN}/logs
  mkdir /var/www/${DOMAIN}/backups
}

demoFile() {
  # Demo index.html page
  echo -e "${Cyan}Creating demo index.html .. ${Color_Off}"
  touch /var/www/${DOMAIN}/public_html/index.html

  echo -e "<DOCTYPE html>
<html lang='en'>
  <head>
    <title>Welcome to ${DOMAIN}!</title>
  </head>
  <body>
    <h1>Success! The ${DOMAIN} virtual host is working!</h1>
  </body>
</html>
" > /var/www/${DOMAIN}/public_html/index.html
}

setPerms() {
  echo -e "${Cyan}Setting Permissions .. ${Color_Off}"
  # sets the user running the script as owner
  # sudo chown -R $USER:$USER /var/www/${DOMAIN}

  # set www-data as the owner of the domain
  sudo chown -R www-data:www-data /var/www/${DOMAIN}

  # set directory permissions
  chmod -R 755 /var/www/${DOMAIN}
}

createConf() {
  # create virtual host file
  echo -e "${Cyan}Creating virtual host file for ${DOMAIN} .. ${Color_Off}"
  touch /etc/apache2/sites-available/${DOMAIN}.conf
  
  # add config
  echo -e "# domain: ${DOMAIN}
# public: /var/www/${DOMAIN}/public_html/
# logs: /var/www/${DOMAIN}/logs/

<VirtualHost *:80>

    # Admin email, Server Name (domain name), and any aliases
    ServerAdmin webmaster@${DOMAIN}
    ServerName ${DOMAIN}
    ServerAlias www.${DOMAIN}
  
    # Index file and Document Root (where the public files are located)
    DirectoryIndex index.html index.php
    DocumentRoot /var/www/${DOMAIN}/public_html

    # Allow .htaccess and Rewrites
    <Directory /var/www/${DOMAIN}/public_html>
      Options FollowSymLinks
      AllowOverride All
    </Directory>
    
    # Log file locations
    LogLevel warn
    ErrorLog /var/www/${DOMAIN}/logs/error.log
    CustomLog /var/www/${DOMAIN}/logs/access.log combined
    
    # Custom php.ini path
    # PHPINIDir /var/www/${DOMAIN}/public_html/

</VirtualHost>" > /etc/apache2/sites-available/${DOMAIN}.conf
}

installCertbot() {
  # install Let's Encrypt Certbot
  sudo apt-get update -qq 
  sudo apt-get install -qq software-properties-common
  sudo add-apt-repository universe
  sudo add-apt-repository ppa:certbot/certbot
  sudo apt-get update -qq 
  sudo apt-get install -qq certbot python3-certbot-apache
}

installSSL() {
  # install SSL
  # will only install on the domains you provide when running the script, will not cover www versions..
  # you can specify email with --email ${SSL_EMAIL}
  # if no email, use the --register-unsafely-without-email flag
  certbot --apache --non-interactive --agree-tos --register-unsafely-without-email --domains ${DOMAIN}
}

SETUP() {
  checkExistingConf # check if a .conf file exists for the given domain
  checkExistingDir # check if a directory in /var/www/ exists for the given domain

  createFiles
  createConf
  enableSite
  disableDefault
  setPerms
  demoFile

  #echo -e "${Green}Installing SSL on ${DOMAIN} ${Color_Off}"
  #installCertbot
  #installSSL

  echo -e "${Cyan}${DOMAIN} has been successfully set up! ${Color_Off}"
}

# EXECUTE
#########################################

  if [ $# -eq 0 ]; then # if no. of args provided is 0
    showUsage
    exit 1
  elif [ $# -gt 1 ]; then # if no. of args (domains) provided is more than 1
    checkApacheInstall # check if Apache is installed
    for arg in "$@" # for every argument in all arguments provided `$@`
    do
      DOMAIN=${arg}
      SETUP # run the setup script
    done
    restartApache
    exit 0
  else
    checkApacheInstall # check if Apache is installed
    DOMAIN=$1
    SETUP # run the setup script
    restartApache
    exit 0
  fi
