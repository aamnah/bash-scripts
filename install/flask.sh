#!/bin/bash

# check if apaceh is installed, if not, install apache
# check if pip is installed, if not, install pip
# check if virtualenv is installed, if not, install virtualenv
# automatically generate a salt and insert in place of application.secret_key

# Variables
###########
APP_NAME='flaskApp'
APP_PATH=/var/www/${APP_NAME}
FOLDER_STATIC='static'
FOLDER_TEMPLATE='templates'
SERVER_NAME='mydomain.com'
SERVER_ADMIN='me@email.com'
SECRET_KEY='your_very_secret_key'

# generate a random string
# SALT=cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1

# Installs
##########
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install apache2 -y
sudo apt-get install libapache2-mod-wsgi # Flask req
sudo a2enmod wsgi 
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install python-pip -y
sudo pip install virtualenv
service apache2 restart


# App Directory structure
#########################
mkdir -p ${APP_PATH}/${APP_NAME}/ # e.g. flaskapp inside flaskapp 
cd ${APP_PATH}/${APP_NAME}/
mkdir ${FOLDER_STATIC}
mkdir ${FOLDER_TEMPLATE} 
touch __init__.py
echo -e "
from flask import Flask  # import Flask

app = Flask(__name__) # define your Flask app

@app.route('/') # define home page
def homepage():
    return \"Bonjour la monde!\"
    
if __name__ == \"__main__\":
    app.run()
" > __init__.py

# pip & virtualenv
cd ${APP_PATH}/${APP_NAME}/
virtualenv venv
source venv/bin/activate
pip install Flask
# python __init__.py # test your setup

# Conf files
############
touch /etc/apache2/sites-available/${APP_NAME}.conf
echo -e "
<VirtualHost *:80>
  ServerName ${SERVER_NAME}
  ServerAdmin ${SERVER_ADMIN}
  
  # wsgi parameteres
  WSGIScriptAlias / ${APP_PATH}/${APP_NAME}.wsgi
  <Directory ${APP_PATH}/${APP_NAME}/> 
    Order allow,deny
    Allow from all
  </Directory>
  
  # Static parameters
  Alias /static ${APP_PATH}/${APP_NAME}/static/
  <Directory ${APP_PATH}/${APP_NAME}/static/c>
    Order allow,deny
    Allow from all
  </Directory>
  
  # Error Logging
  ErrorLog ${APACHE_LOG_DIR}/error.log
  LogLevel warn
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/${APP_NAME}.conf

sudo a2ensite ${APP_NAME}
service apache2 reload

# WSGI conf
touch ${APP_PATH}/${APP_NAME}.wsgi
echo -e "
#!/bin/bash/python

import sys
import logging

logging.basicConfig(stream=sys.stderr)
sys.path.insert(0,\"${APP_PATH}/${APP_NAME}/\")

from flaskApp import app as application
application.secret_key = \"${SECRET_KEY}\"
" > ${APP_PATH}/${APP_NAME}.wsgi

service apache2 restart
