#!/bin/bash


# This script watches a directory for changes and notify rscync_cron.sh to sync the changes to the target directory

# The directory to watch
WATCH_DIR="/home/admzimmermann/watch_dir"

# The target directory
TARGET_DIR="/home/admzimmermann/target_dir"

# The script to run when changes are detected
SYNC_SCRIPT="/home/admzimmermann/rsync_cron.sh"

# The rsync options
RSYNC_OPTIONS="-avz --delete"

# The rsync command
RSYNC_CMD="rsync $RSYNC_OPTIONS $WATCH_DIR/ $TARGET_DIR"

# The inotifywait command
INOTIFY_CMD="inotifywait -m -r -e create,delete,modify,move $WATCH_DIR"

# Start the inotifywait command
$INOTIFY_CMD | while read path action file; do
    # Run the rsync command
    $RSYNC_CMD
done    

# End of script