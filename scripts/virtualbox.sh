#!/bin/bash

# Check we are running inside VirtualBox.
if [[ $( dmidecode | egrep -q 'Product Name: VirtualBox' ) -ne 0 ]]; then
    exit 0
fi

echo "Installing needed packages for Virtualbox Guest Additions"
apt-get -qq -y install linux-headers-$(uname -r) build-essential dkms wget

VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
VBOX_ISO=VBoxGuestAdditions_${VBOX_VERSION}.iso

if [ ! -f $VBOX_ISO ] ; then
    echo "No Virtualbox Guest Additions ISO found"
	echo "Downloading ${VBOX_ISO} instead"
   	wget -q http://download.virtualbox.org/virtualbox/${VBOX_VERSION}/${VBOX_ISO} -O $VBOX_ISO
	wget -q http://download.virtualbox.org/virtualbox/${VBOX_VERSION}/SHA256SUMS -O - \
		| grep ${VBOX_ISO}$ \
		| sha256sum -c - \
		|| exit 1
fi

echo "Installing Virtualbox Guest Additions ${VBOX_VERSION} without X11 support"
mount -o loop $VBOX_ISO /mnt
sh /mnt/VBoxLinuxAdditions.run --nox11
umount /mnt

echo "Removing Virtualbox Guest Additions build packages"
apt-get -qq -y remove linux-headers-$(uname -r) build-essential
apt-get -qq -y autoremove
