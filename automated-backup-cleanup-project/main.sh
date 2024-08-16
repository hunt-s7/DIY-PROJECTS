#!/bin/bash

#Directories to backup (load it from a text-file)
BACKUP_DIR_FILE="/path/backupdir.txt"

#This will contain the periodic logs of our process
LOG_FILE="/path/test-area/backup/logfile.txt"

if [[ -f "$BACKUP_DIR_FILE" ]]; then
	mapfile -t BACKUP_DIRS < <(cat "$BACKUP_DIR_FILE")
else
	echo "[$(date)] Backup directories not found: $BACKUP_DIR_FILE" >> "$LOG_FILE"
fi

#Destination, where the backups will be stored
BACKUP_DEST="/path/test-area/backup/"

#How long a backup should last
RETENTION_DAYS=7

#Lets create our backup function
backup() {
	for DIR in "${BACKUP_DIRS[@]}"; do
		#Lets pickout the directory name fram base name
		#Also, we will use it to name our tar file
		DIR_NAME=$(basename "$DIR")
		TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
		BACKUP_FILE="$BACKUP_DEST/${DIR_NAME}_backup_$TIMESTAMP.tar.gz"

		#Log the directory being backed-up
		echo "[$(date)] Starting backup for directory: $DIR" >> "$LOG_FILE"

		#Create the backup for each directory individually
		tar -czf "$BACKUP_FILE" -C "$(dirname "$DIR")" "$DIR_NAME"

		if [[ $? -eq 0 ]]; then
			echo "[$(date)] Backup successfully crated: $BACKUP_FILE" >> "$LOG_FILE"
		else
			echo "[$(date)] Backup failed for directory: $DIR" >> "$LOG_FILE"
		fi
	done
}

# Cleanup function
cleanup() {
	echo "[$(date)] Starting cleanup of backups older than $RETENTION_DAYS days" >> "$LOG_FILE"
	
	#Find old backups
	OLD_BACKUPS=$(find "$BACKUP_DEST" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS)

	if [[ -z "$OLD_BACKUPS" ]]; then
		echo "[$(date)] No backups older than $RETENTION_DAYS days found." >> "$LOG_FILE"
	else
		#Delete old backups
		find "$BACKUP_DEST" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec rm {} \;

		if [[ $? -eq 0 ]]; then
			echo "[$(date)] Cleanup performed. Backups older than $RETENTION_DAYS days deleted." >> "$LOG_FILE"
		else
			echo "[$(date)] Cleanup failed. Some old backups may still exists." >> "$LOG_FILE"
		fi
	fi
}


#main function

main() {
	backup
	cleanup
}

main

















