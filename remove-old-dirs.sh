#!/bin/bash

echo -e "\nSCRIPT: Backup Directory Retention\n"

echo -e "-----------------------------------------------------------------------------------------------------"
echo -e "   WARNING: This script automates destructive removal of directories on the filesystem!"
echo -e "            Ensure correct values in 'retention.config' before setting RETENTION_DRY_RUN to false!"
echo -e "------------------------------------------------------------------------------------------------------\n"

sleep_seconds=5
config_file=$(pwd)/retention.config
source $config_file

if [[ -z "$RETENTION_DRY_RUN" ]]; then
    echo -e "\nERROR: Must provide value for RETENTION_DRY_RUN in 'retention.config'!\n" 1>&2
    exit 1
fi

if [[ -z "$RETENTION_ROOT_DIR" ]]; then
    echo -e "\nERROR: Must provide value for RETENTION_ROOT_DIR in 'retention.config'!\n" 1>&2
    exit 1
elif [[ ! -d "$RETENTION_ROOT_DIR" ]]; then
    echo -e "\nERROR: Root path specified in 'retention.config' ($RETENTION_ROOT_DIR) does not exist!\n" 1>&2
    exit 1
fi

if [[ -z "$RETENTION_MAX_AGE" ]]; then
    echo -e "\nERROR: Must provide value for RETENTION_MAX_AGE in 'retention.config'!\n" 1>&2
    exit 1
fi

echo -e "CONFIGURATION:"
echo -e "  > Dry run active:        $RETENTION_DRY_RUN"
echo -e "  > Root backup path:      $RETENTION_ROOT_DIR"
echo -e "  > Remove older than:     $RETENTION_MAX_AGE days\n"


dirs_to_remove=$(find $RETENTION_ROOT_DIR -mindepth 1 -maxdepth 1 -type d -mtime +$RETENTION_MAX_AGE)

if [[ -z "$dirs_to_remove" ]]; then
    echo -e "No directories last modified more than $RETENTION_MAX_AGE days ago. Nothing to do.\n" 1>&2
    exit 0
fi

echo -e "DIRECTORIES TO REMOVE:"

for dir in ${dirs_to_remove[@]}; do
    echo -e "  - ${dir}"
done

if [[ ${RETENTION_DRY_RUN,,?} == "false" ]]; then
    echo -e "\n\nWARNING: This is not a dry run, the directories and their contents will be permanently deleted!!!\n" 1>&2
    echo -e "The script will continue in $sleep_seconds seconds! Press CTRL-C to abort!\n"
    sleep $sleep_seconds
    echo -e "REMOVING:"
    for dir in ${dirs_to_remove[@]}; do
        printf "  - ${dir}..."
        rm -fr ${dir}
        printf " removed\n"
    done
else
    echo -e "\nThis was a dry run, nothing was deleted.\nSet 'RETENTION_DRY_RUN=false' to enable destructive actions."
fi

echo -e "\nDone.\n"