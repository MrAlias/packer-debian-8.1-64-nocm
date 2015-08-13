#!/bin/bash

# Check we are running inside VirtualBox.
if [[ $( dmidecode | egrep -q 'Product Name: VirtualBox' ) -ne 0 ]]; then
    exit 0
fi

echo "Installing needed packages for Virtualbox Guest Additions"
apt-get -qq -y install linux-headers-$(uname -r) build-essential dkms

VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
VBOX_ISO=/home/vagrant/VBoxGuestAdditions_${VBOX_VERSION}.iso

if [ ! -f $VBOX_ISO ] ; then
    echo "No Virtualbox Guest Additions ISO found"
    ls -lh /home/vagrant
    exit 1
fi

echo "Installing Virtualbox Guest Additions with X11 support"
mount -o loop $VBOX_ISO /mnt
sh /mnt/VBoxLinuxAdditions.run --nox11
umount /mnt

echo "Removing Virtualbox Guest Additions build packages"
rm $VBOX_ISO
apt-get -qq -y remove linux-headers-$(uname -r) build-essential
apt-get -qq -y autoremove
