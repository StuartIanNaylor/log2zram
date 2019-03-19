#!/bin/bash

systemctl -q is-active log2zram  && { echo "ERROR: log2zram service is still running. Please run \"sudo service log2zram stop\" to stop it and uninstall"; exit 1; }
[ "$(id -u)" -eq 0 ] || { echo "You need to be ROOT (sudo can be used)"; exit 1; }
[ -d /usr/local/bin/log2zram ] && { echo "Log2Zram is already installed, uninstall first"; exit 1; }


# log2zram install 
mkdir -p /usr/local/bin/log2zram
install -m 644 log2zram.service /etc/systemd/system/log2zram.service
install -m 755 log2zram /usr/local/bin/log2zram/log2zram
install -m 644 log2zram.conf /etc/log2zram.conf
install -m 755 log2zram-schd /usr/local/bin/log2zram/log2zram-schd
install -m 644 log2zram-schd-pid /usr/local/bin/log2zram/log2zram-schd-pid
install -m 644 uninstall.sh /usr/local/bin/log2zram/uninstall.sh
systemctl enable log2zram


# Make sure we start clean
rm -rf /var/hdd.log
mkdir -p /var/log/oldlog
mkdir -p /var/hdd.log
mkdir -p /var/prune.log

# Prune logs
cp -a /var/log/*.1 /var/prune.log > /dev/null 2>&1 &
cp -a /var/log/*.gz /var/prune.log > /dev/null 2>&1 &
cp -a /var/log/*.old /var/prune.log > /dev/null 2>&1 &

rm -r /var/log/*.1 > /dev/null 2>&1 &
rm -r /var/log/*.gz > /dev/null 2>&1 &
rm -r /var/log/*.old > /dev/null 2>&1 &


sed -i '/^weekly.*/i olddir /var/log/oldlog' /etc/logrotate.conf

echo "#####          Reboot to activate log2zram         #####"
echo "##### edit /etc/log2zram.conf to configure options #####"
