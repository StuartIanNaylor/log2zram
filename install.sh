#!/bin/bash

systemctl -q is-active log2zram  && { echo "ERROR: log2zram service is still running. Please run \"sudo service log2zram stop\" to stop it and uninstall"; exit 1; }
[ "$(id -u)" -eq 0 ] || { echo "You need to be ROOT (sudo can be used)"; exit 1; }
[ -d /usr/local/bin/log2zram ] && { echo "Log2Zram is already installed, uninstall first"; exit 1; }


# log2zram install 
mkdir -p /usr/local/bin/log2zram
install -m 644 log2zram.service /etc/systemd/system/log2zram.service
install -m 755 log2zram /usr/local/bin/log2zram/log2zram
install -m 644 log2zram.conf /etc/log2zram.conf
install -m 644 log2zram.log /usr/local/bin/log2zram/log2zram.log
install -m 644 uninstall.sh /usr/local/bin/log2zram/uninstall.sh
systemctl enable log2zram

# cron
install -m 755 log2zram.hourly /etc/cron.hourly/log2zram
install -m 644 log2zram.logrotate /etc/logrotate.d/log2zram

# Make sure we start clean
rm -rf /var/hdd.log
mkdir -p /var/hdd.log
mkdir -p /var/log/oldlog
chmod 754 /var/log/oldlog
chown root:adm /var/log/oldlog
# Prune logs
cp -au /var/log/*.1 /var/log/oldlog > /dev/null 2>&1 &
cp -au /var/log/*.gz /var/log/oldlog > /dev/null 2>&1 &
cp -au /var/log/*.old /var/log/oldlog > /dev/null 2>&1 &

rm -r /var/log/*.1 > /dev/null 2>&1 &
rm -r /var/log/*.gz > /dev/null 2>&1 &
rm -r /var/log/*.old > /dev/null 2>&1 &
# Clone /var/log
echo "#####               Clone /var/log                 #####"
rsync -arzhv /var/log/ /var/hdd.log/

sed -i '/^include.*/i olddir /var/log/oldlog' /etc/logrotate.conf

echo "#####          Reboot to activate log2zram         #####"
echo "##### edit /etc/log2zram.conf to configure options #####"
