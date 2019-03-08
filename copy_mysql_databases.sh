#!/bin/bash

###################################################################
#         Author: Aamnah Akram
#           Link: http://aamnah.com
#    Description: Syncs `/var/lib/mysql` from remote server to local `/var/lib/mysql` dir
#                 essentially copying all MySQL Databases with Users and Permissions
#                 and logs the progress in a text file
###################################################################

# Pre-requisites
# 1. install mysql-server
# 2. setup SSH keys for password-less access

LOGFILE="${HOME}/rsync_log.txt"
#REMOTE_HOST='123.123.123.123' # server 1
REMOTE_HOST='456.456.456.456' # server 2
REMOTE_USER='root'
REMOTE_PORT='2200'

# Create log file
touch ${LOGFILE}

echo -e "
START Copying MySQL dir -  $(date '+%Y %b %d _ %H:%M')
--------------------------------------------- 
" >> ${LOGFILE}

# Sync MySQL databases (with users and permissions)
rsync -vPhaze "ssh -i /root/.ssh/id_rsa -p ${REMOTE_PORT}" ${REMOTE_USER}@${REMOTE_HOST}:/var/lib/mysql/ /var/lib/mysql/ &>> ${LOGFILE}

echo -e "
---------------------------------------------
END Copying MySQL dir -  $(date '+%Y %b %d _ %H:%M')
\n\n" >> ${LOGFILE}

# NOTES
# `&>>` redirects both stdout and stderr 
# run this with Cron so that it keeps running without you sitting at the Terminal
# you can check progress with `tail -f logfilename.txt`
