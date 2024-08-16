<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="A Bash script to automate directory backups and cleanup, with logging and individual archive creation. Perfect for Linux users and shell scripting enthusiasts.">
    <meta name="keywords" content="Bash, Linux, shell scripting, automation, backup script, data management, DIY project, logging, cleanup">
    <meta name="author" content="Satyam Goel">
</head>
<body>

<h1>Automated Backup and Cleanup Script Using Bash</h1>

<p>This project provides a Bash script to automate the backup of directories and manage old backups. The script reads directories from a specified file, creates individual compressed archives, and cleans up old backups based on retention rules, all while logging each step for easy tracking.</p>

<h2>Script Explanation</h2>

<h3>Loading Directories to Back Up</h3>
<p>The directories to back up are read from <code>backupdir.txt</code> using the <code>mapfile</code> command. If the file is not found, the script logs an error and exits.</p>

<pre><code>if [[ -f "$BACKUP_DIR_FILE" ]]; then
    mapfile -t BACKUP_DIRS &lt; &lt;(cat "$BACKUP_DIR_FILE")
else
    echo "[$(date)] Backup directories file not found: $BACKUP_DIR_FILE" >> "$LOG_FILE"
    exit 1
fi
</code></pre>

<h3>Backup Process</h3>
<p>The <code>backup</code> function creates a timestamped backup file for each specified directory. It logs which directories are being backed up and whether the backup was successful.</p>

<pre><code>backup() {
    for DIR in "${BACKUP_DIRS[@]}"; do
        DIR_NAME=$(basename "$DIR")
        TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
        BACKUP_FILE="$BACKUP_DEST/${DIR_NAME}_backup_$TIMESTAMP.tar.gz"
        tar -czf "$BACKUP_FILE" -C "$(dirname "$DIR")" "$DIR_NAME"
        if [[ $? -eq 0 ]]; then
            echo "[$(date)] Backup successfully created: $BACKUP_FILE" >> "$LOG_FILE"
        else
            echo "[$(date)] Backup failed for directory: $DIR" >> "$LOG_FILE"
        fi
    done
}
</code></pre>

<h3>Cleanup Process</h3>
<p>The <code>cleanup</code> function finds and deletes backups older than the specified number of days (<code>RETENTION_DAYS</code>). The script logs the start of the cleanup process and whether the deletion was successful.</p>

<pre><code>cleanup() {
    OLD_BACKUPS=$(find "$BACKUP_DEST" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS)
    if [[ -z "$OLD_BACKUPS" ]]; then
        echo "[$(date)] No backups older than $RETENTION_DAYS days found." >> "$LOG_FILE"
    else
        find "$BACKUP_DEST" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec rm {} \;
        if [[ $? -eq 0 ]]; then
            echo "[$(date)] Cleanup performed. Backups older than $RETENTION_DAYS days deleted." >> "$LOG_FILE"
        else
            echo "[$(date)] Cleanup failed. Some old backups may still exist." >> "$LOG_FILE"
        fi
    fi
}
</code></pre>

<h3>Logging</h3>
<p>All significant actions are logged to <code>logfile.log</code>, making it easier to track the script's performance over time.</p>

<h2>Explanation of the Changes</h2>

<h3>Individual Tar Files</h3>
<p>The script loops over each directory in <code>backupdir.txt</code>, creating a separate tar file for each directory.</p>
<ul>
    <li><code>basename "$DIR"</code>: Extracts the directory name (e.g., <code>/path/to/dir</code> becomes <code>dir</code>) to use in the tar file's name.</li>
    <li><code>tar -czf "$BACKUP_FILE" -C "$(dirname "$DIR")" "$DIR_NAME"</code>: Creates a tar file for each directory individually.</li>
</ul>

<h3>Logging</h3>
<p>The script logs the start and success/failure of each directory's backup, as well as the cleanup process.</p>

<h3>Backup File Naming</h3>
<p>Each tar file is named using the directory's basename followed by a timestamp, ensuring that each backup file is unique.</p>

<h2>Usage</h2>

<ol>
    <li>Ensure your <code>backupdir.txt</code> is properly set up with the directories you want to back up, one per line.</li>
    <li>Run the script:</li>
</ol>

<pre><code>./main.sh
</code></pre>

</body>
</html>
