#!/bin/bash

if [ "$(id -u)" -eq 0 ]
then
	systemctl stop log2zram 
	systemctl disable log2zram
	rm /etc/systemd/system/log2zram.service
	rm /usr/local/bin/log2zram
	rm /etc/log2zram.conf
	rm /etc/logrotate.d/00_log2zram
	echo "Log2Zram is uninstalled, removing the uninstaller in progress"
	rm -rf /usr/local/share/log2zram
	rm -rf /usr/local/lib/log2zram
	echo "##### Reboot isn't needed #####"
else
	echo "You need to be ROOT (sudo can be used)"
fi
