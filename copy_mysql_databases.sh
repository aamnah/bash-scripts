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
REMOTE_PORT='22'
REMOTE_PATH='/var/lib/mysql/'
LOCAL_PATH='/var/lib/mysql/'
SSH_KEY='/root/.ssh/id_rsa'


# Create log file
touch ${LOGFILE}

echo -e "
START Copying MySQL dir - $(date '+%Y %b %d _ %H:%M:%S')
--------------------------------------------- 
" >> ${LOGFILE}

# Sync MySQL databases (with users and permissions)
rsync -vPhaze "ssh -i ${SSH_KEY} -p ${REMOTE_PORT}" ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH} ${LOCAL_PATH} &>> ${LOGFILE}

echo -e "
---------------------------------------------
END Copying MySQL dir -  $(date '+%Y %b %d _ %H:%M:%S')
\n\n" >> ${LOGFILE}

# NOTES
# `&>>` redirects both stdout and stderr 
# run this with Cron so that it keeps running without you sitting at the Terminal
# you can check progress with `tail -f logfilename.txt`
