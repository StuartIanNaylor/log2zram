#!/bin/bash

systemctl -q is-active log2zram  && { echo "ERROR: log2zram service is still running. Please run \"sudo service log2zram stop\" to stop it and uninstall"; exit 1; }
[ "$(id -u)" -eq 0 ] || { echo "You need to be ROOT (sudo can be used)"; exit 1; }
[ -d /usr/local/bin/log2zram ] && { echo "Log2Zram is already installed, uninstall first"; exit 1; }

mkdir -p /usr/local/share/log2zram/
# log2zram install 
install -m 644 log2zram.service /etc/systemd/system/log2zram.service
install -m 755 log2zram /usr/local/bin/log2zram
install -m 644 log2zram.conf /etc/log2zram.conf
install -m 644 uninstall.sh /usr/local/share/log2zram/uninstall.sh
systemctl enable log2zram


# Make sure we start clean
rm -rf /var/hdd.log
mkdir -p /var/hdd.log
mkdir -p /usr/local/share/log2zram/log


