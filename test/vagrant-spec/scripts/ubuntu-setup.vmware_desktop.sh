#!/bin/bash
set -xe

WORKSTATION_DOWNLOAD_URL="${WORKSTATION_DOWNLOAD_URL:-https://www.vmware.com/go/getworkstation-linux}"

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -yq curl build-essential libxinerama1 libxcursor1 libxtst6 libxi6 linux-kernel-headers open-vm-tools libpcsclite1
apt-get install -yq linux-headers-$(uname -a | awk '{print $3}')
curl -Ss -f -L -o ./vmware-installer "${WORKSTATION_DOWNLOAD_URL}"
chmod a+x ./vmware-installer
./vmware-installer --eulas-agreed --required
vmware-modconfig --console --install-all
/usr/lib/vmware/bin/vmware-vmx-debug --new-sn ${VMWARE_SN}

pushd /vagrant

dpkg -i vagrant_*_x86_64.deb
vagrant plugin install ./vagrant-spec.gem
vagrant plugin install vagrant-vmware-desktop
vagrant plugin license vagrant-vmware-desktop /vagrant-home/license-vagrant-vmware-desktop.lic

popd
