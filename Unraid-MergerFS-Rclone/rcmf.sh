#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

if test -f "/root/.migration/.config/systemd/user/rclone-vfs.service"; then
   cp /root/.migration/.config/systemd/user/rclone-vfs.service /root/.config/systemd/user/
   sed -i -E "s+/home[0-9]{0,2}/\w*+%h+g" /root/.config/systemd/user/rclone-vfs.service
   systemctl --user daemon-reload
   systemctl --user -q enable rclone-vfs.service
   systemctl --user -q restart rclone-vfs.service
   sleep 3
   systemctl --user -q is-active rclone-vfs.service && echo -e "${GREEN}rclone-vfs service edited and restarted successfully.${NOCOLOR}"
   systemctl --user -q is-failed rclone-vfs.service && echo -e "${RED}rclone-vfs service edited and failed to start. Check rclone mount log.${NOCOLOR}"
fi

if test -f "/root/.migration/.config/systemd/user/mergerfs.service"; then
   cp /root/.migration/.config/systemd/user/mergerfs.service /root/.config/systemd/user/
   sed -i -E "s+/home[0-9]{0,2}/\w*+%h+g" /root/.config/systemd/user/mergerfs.service
   systemctl --user daemon-reload
   systemctl --user -q enable mergerfs.service
   systemctl --user -q restart mergerfs.service
   sleep 3
   systemctl --user -q is-active mergerfs.service && echo -e "${GREEN}mergerfs service edited and restarted successfully.${NOCOLOR}"
   systemctl --user -q is-failed mergerfs.service && echo -e "${RED}mergerfs service edited and failed to start. Check mergerfs mount log.${NOCOLOR}"
fi

if test -f "/root/.migration/.config/systemd/user/rclone-uploader.service" && test -f "/root/.migration/.config/systemd/user/rclone-uploader.timer"; then
   cp /root/.migration/.config/systemd/user/rclone-uploader.service /root/.config/systemd/user/ && cp /root/.migration/.config/systemd/user/rclone-uploader.timer /root/.config/systemd/user/
   sed -i -E "s+/home[0-9]{0,2}/\w*+%h+g" /root/.config/systemd/user/rclone-uploader.service
   systemctl --user daemon-reload
   systemctl --user -q enable --now rclone-uploader.service && systemctl --user -q enable --now rclone-uploader.timer
   echo -e "${GREEN}rclone-uploader service & timer edited and enabled${NOCOLOR}"
fi


if [[ -z $(grep '[^[:space:]]' "/root/.migration/crontab.dump") ]] ; then
   exit
fi

cp "/root/.migration/crontab.dump" "/root/.migration/crontab.dump.temp"
sed -i -E "s+/home[0-9]{0,2}/[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)/+/home/$USER/+g" "/root/.migration/crontab.dump.temp"
crontab "/root/.migration/crontab.dump.temp"
rm "/root/.migration/crontab.dump.temp"
echo -e "${GREEN}crontab restored.${NOCOLOR}"

exit
