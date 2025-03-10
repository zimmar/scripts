#!/bin/bash

# rsync_cron.sh
# Author: Martin Zimmermann
# Date: 2021-09-26
# Version: 1.0

# This script is used to rsync files from a source to a destination
# and remove the source files after the rsync is done.
# The script is intended to be run as a cron job.
# The script will be run every 5 minutes.
# The entry in the crontab will look like this:
# */5 * * * * /path/to/rsync_cron.sh

# The script will check if it is already running and exit if it is.
# It will also create a PID file to prevent multiple instances of the script from running.

# The script will log all output to a log file.
# The log file will be rotated by logrotate.

# The script will also trap SIGHUP, SIGINT, and SIGTERM signals to cleanup the PID file.

# The logfile will be created in /var/log/rsync_log/rsync_cron.log
# The log file must be created with the correct permissions:
# sudo touch /var/log/rsync_log/rsync_cron.log
# sudo chown admzimmermann:admzimmermann /var/log/rsync_log/rsync_cron.log

# The source directory is /mnt/nas/media/*.*
# The destination directory is /home/paperless_usr/paperless_ngx/consume/
# The PID file will be created in /tmp/rsync_cron.pid

LOGFILE=/var/log/rsync_log/rsync_cron.log
PIDFILE=/tmp/rsync_cron.pid
# Change the entries
SOURCE=/home/<userid>/Dokumente/privat/*.*
DESTINATION=/home/<userid>/Dokumente/privat/backup/

function cleanup {
    # Remove the PID file
    rm -f $PIDFILE
    exit 0
}

trap cleanup SIGHUP SIGINT SIGTERM

# Check if the script is already running
if [ -f "$PIDFILE" ] && kill -0 $(cat $PIDFILE); then
    echo "rsync_cron.sh is already running" >&2 | tee -a $LOGFILE
    exit 1
fi

# Create the PID file
echo $$ > $PIDFILE

# Check if the PID file was created successfully
if [ $? -ne 0 ]; then
    echo "Could not create PID file" >&2 | tee -a $LOGFILE
    exit 1
fi

rsync --remove-source-files \
    --info=ALL2 \
    --log-file=$LOGFILE \
    # change the entries
    --exclude="@*.*" \
    --exclude="*.tmp" \
    --exclude="*.part" \
    --exclude="*.crdownload" \
    --exclude="*.bak" \
     $SOURCE $DESTINATION
     
# Cleanup if rsync ready
cleanup
