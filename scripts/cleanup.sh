#!/bin/bash

echo "Cleaning up unneeded packages and package cache"
apt-get -qq -y purge $(dpkg --list |grep '^rc' |awk '{print $2}')
apt-get -qq -y purge $(dpkg --list |egrep 'linux-image-[0-9]' |awk '{print $3,$2}' |sort -nr |tail -n +2 |grep -v $(uname -r) |awk '{ print $2}')
apt-get -qq -y autoremove
apt-get -qq -y clean

echo "Cleaning up VBoxGuestAdditions ISOs"
rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?

echo "Cleaning up dhcp leases"
rm /var/lib/dhcp/*

echo "Cleaning up udev rules"
if [ -e /etc/udev/rules.d/70-persistent-net.rules ]; then
    rm /etc/udev/rules.d/70-persistent-net.rules
    mkdir /etc/udev/rules.d/70-persistent-net.rules
fi
if [ -e /dev/.udev/ ]; then
    rm -rf /dev/.udev/
fi
if [ -e /lib/udev/rules.d/75-persistent-net-generator.rules ]; then
    rm /lib/udev/rules.d/75-persistent-net-generator.rules
fi

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces

echo "Cleaning up bash history"
unset HISTFILE
[ -f /root/.bash_history ] && rm /root/.bash_history
[ -f /home/vagrant/.bash_history ] && rm /home/vagrant/.bash_history

echo "Cleaning up log files"
find /var/log -type f | while read f; do echo -ne '' > $f; done
