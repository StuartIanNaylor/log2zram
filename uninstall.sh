#!/bin/bash

if [ "$(id -u)" -eq 0 ]
then
	service log2zram stop
	systemctl disable log2zram
	rm /etc/systemd/system/log2zram.service
	rm /usr/local/bin/log2zram/log2zram
	rm /usr/local/bin/log2zram/log2zram-schd
	rm /usr/local/bin/log2zram/log2zram-schd-pid
	rm /etc/log2zram.conf

	sudo sed -i '/olddir.*/d' /etc/logrotate.conf
	mv /usr/local/bin/log2zram/logrotate /etc/cron.daily/logrotate > /dev/null 2>&1 &
	echo "Log2Zram is uninstalled, removing the uninstaller in progress"
	rm -rf /usr/local/bin/log2zram
	echo "##### Reboot isn't needed #####"
else
	echo "You need to be ROOT (sudo can be used)"
fi
