#!/bin/bash

# rclone beta Installer/Updater by Xan#7777

if pgrep "rclone";
then
    echo "Rclone is running. Please close all rclone instances before proceeding."
    exit
else
    clear
    echo "Installing/Upgrading rclone beta..."
    mkdir -p /root/.rclone-tmp
    wget https://beta.rclone.org/rclone-beta-latest-linux-amd64.zip -O /root/.rclone-tmp/rclone.zip
    unzip /root/.rclone-tmp/rclone.zip -d /root/.rclone-tmp/
    cp /root/.rclone-tmp/rclone-v*/rclone /root/bin
fi

clear

if [[ $(/root/bin/rclone version) ]]; then
    echo "rclone is installed correctly!"
    rm -rf /root/.rclone-tmp
    exit 0
else
    echo "rclone install somehow failed. Please run this again!"
    rm -rf /root/.rclone-tmp
    exit 1
fi