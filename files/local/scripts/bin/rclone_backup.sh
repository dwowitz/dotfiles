#!/usr/bin/env bash
#
# rclone_backup.sh
# Copyright (C) 2017 Danny Berkowitz <dwowitz@gmail.com>
#
# Distributed under terms of the MIT license.
#
#
# Description:
# Use rclone to backup my home directory to cloud storage
# and log the output.

LOG_DIR="$HOME/.log"
BKUP_ACCT="dwowitz_drive"
EXCLUDE_FILE="$HOME/.config/rclone/exclude.rules"
SRC_DIR="$HOME"
DEST_DIR="/dwowitz_archsp3_BKUP"
RC_CMD="sync"

# Private
bname=$(basename "$0")
sname=${bname%.*}
logname=$sname-$(date +"%m%d%Y").log

#rclone \
#--exclude-from $EXCLUDE_FILE \
#$RC_CMD -L $SRC_DIR ${BKUP_ACCT}:${DEST_DIR} \
#>> ${LOG_DIR}/${logname} 2>&1

echo "I'm Broken... Fix Me!!!"
