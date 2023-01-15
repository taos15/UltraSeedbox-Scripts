#!/bin/bash

lock_file="/root/scripts/rclone-upload.lock"

trap 'rm -f "$lock_file"; exit 0' SIGINT SIGTERM
if [ -e "$lock_file" ]
then
    echo "Rclone upload script is already running."
    exit
else
    rm /root/scripts/rclone-upload.log
    touch "$lock_file"
    /root/bin/rclone move /root/Stuff/Local/ remote: \
        --config=/root/.config/rclone/rclone.conf \
        --drive-chunk-size 64M \
        --tpslimit 5 \
        -vvv \
        --drive-stop-on-upload-limit \
        --delete-empty-src-dirs \
        --bwlimit=8M \
        --use-mmap \
        --transfers=2 \
        --checkers=4 \
        --log-file /root/scripts/rclone-upload.log
    rm -f "$lock_file"
    trap - SIGINT SIGTERM
    exit
fi
