# Backup Directory Retention Script

Bash script for removing folders based on their last modification age. Run manually or schedule via `cron`.

## Settings

| Name               | Type    | Default          | Description                                                                                                                                                 |
|--------------------|---------|------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `RETENTION_DRY_RUN`  | boolean | `true`             | The script will not make any destructive changes to the system until this is set to `false`. Keep set to `true` until you have manually tested the script.  |
| `RETENTION_ROOT_DIR` | path    | `~/retention-test` | The root path to your backups. All direct child directories at this path will be tested and removed if does not meet retention requirements.                |
| `RETENTION_MAX_AGE`  | integer | `7`                | The number of days to retain a backup directory. Uses the "modified" property to determine age.                                                             |

## Install & Test

1. Clone this repo:

    ```bash
    git clone https://github.com/MaxVRAM/backup-dir-retention.git && cd backup-dir-retention
    ```

2. Update the `retention.config` file with backup path and retention age, leaving dry mode on `RETENTION_DRY_RUN=true`.

3. Launch the script manually from the terminal:

    ```bash
    bash remove-old-dirs.sh
    ```

4. The script will output its current configuration and a list of directories that would be deleted.

5. Once satisfied with the output, you can disable dry mode by setting `RETENTION_DRY_RUN=false` in the `retention.config` file.

## Scheduling

While the script can be run manually from the terminal, you can use `cron` to create a schedule for the script to run in the background.

### Cron job syntax

```bash
 .---------------- minute (0 - 59)
 |  .------------- hour (0 - 23)
 |  |  .---------- day of month (1 - 31)
 |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr …
 |  |  |  |  .---- day of week (0-6) (Sunday=0 or 7)
 |  |  |  |  |            OR sun,mon,tue,wed,thr,fri,sat
 |  |  |  |  |               
 *  *  *  *  *  user-name  command-to-be-executed 
```

### Adding a cron job

1. Install `cron` on your system and enable the `crond` daemon system service. Check online for a guide based on your operating system.

2. Cron jobs are stored in the `/etc/crontab` file, but should be added and removed via the `crontab command`:

    ```bash
    crontab -e
    ```

3. Add a job to execute the script at your desired schedule. You can use this example, just remember to update the user name and script path:

    ```bash
    # Launch the script at 59 minutes passed every hour
    59 * * * * backup-user bash /home/backup-user/backup-dir-retention/remove-old-dirs.sh

    # Launch the script at midnight every day
    0 0 * * * backup-user bash /home/backup-user/backup-dir-retention/remove-old-dirs.sh
    ```

4. Check the job has been added using `crontab -l`, or edit/remove existing ones using `crontab -e` again.

That's it!