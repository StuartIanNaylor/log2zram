#!/bin/bash

if [ "$(id -u)" -eq 0 ]
then
  service log2zram stop
  systemctl disable log2zram
  rm /etc/systemd/system/log2zram.service
  rm /usr/local/bin/log2zram/log2zram
  rm /etc/log2zram.conf
  rm /etc/cron.hourly/log2zram
  rm /etc/logrotate.d/log2zram
  sudo sed -i '/olddir.*/d' /etc/logrotate.conf
  
  echo "Log2Zram is uninstalled, removing the uninstaller in progress"
  rm -rf /usr/local/bin/log2zram
  echo "##### Reboot isn't needed #####"
else
  echo "You need to be ROOT (sudo can be used)"
fi
