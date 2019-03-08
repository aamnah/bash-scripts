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

DATE=`date '+%Y %b %d _ %H:%M'`
LOGFILE='${HOME}/rsync_log.txt'
REMOTE_HOST='123.456.789.123'
REMOTE_USER='root'

# Create log file
touch ${LOGFILE}

echo -e "START Copying MySQL dir - ${DATE}
--------------------------------------------- 
\n" >> ${LOGFILE}

# Sync MySQL databases (with users and permissions)
rsync -vPhaze "ssh -i /root/.ssh/id_rsa" ${REMOTE_USER}@${REMOTE_HOST}:/var/lib/mysql/ /var/lib/mysql/ &>>  ${LOGFILE}

echo -e "\n
---------------------------------------------
END Copying MySQL dir - ${DATE}
\n" >> ${LOGFILE}

# NOTES
# `&>>` redirects both stdout and stderr
# run this with Cron so that it keeps running without you sitting at the Terminal
# you can check progress with `tail -f logfilename.txt`
