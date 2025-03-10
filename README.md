# rsync_cron.sh

## Author: Martin Zimmermann
## Date: 2021-09-26
## Version: 1.0

This script is used to rsync files from a source to a destination
and remove the source files after the rsync is done.
The script is intended to be run as a cron job.
The script will be run every 5 minutes.
The entry in the crontab will look like this:

´´´bash
# */5 * * * * /path/to/rsync_cron.sh
```

The script will check if it is already running and exit if it is.
It will also create a PID file to prevent multiple instances of the script from running.

The script will log all output to a log file.
The log file will be rotated by logrotate.

The script will also trap SIGHUP, SIGINT, and SIGTERM signals to cleanup the PID file.

The logfile will be created in /var/log/rsync_log/rsync_cron.log
The log file must be created with the correct permissions:
```bash
sudo touch /var/log/rsync_log/rsync_cron.log
sudo chown admzimmermann:admzimmermann /var/log/rsync_log/rsync_cron.log
```

The source directory is /mnt/nas/media/*.*
The destination directory is /home/paperless_usr/paperless_ngx/consume/
The PID file will be created in /tmp/rsync_cron.pid
