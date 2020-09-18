#!/bin/bash
set -xe

WORKSTATION_DOWNLOAD_URL="${WORKSTATION_DOWNLOAD_URL:-https://download3.vmware.com/software/wkst/file/VMware-Workstation-Full-15.5.6-16341506.x86_64.bundle}"

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -yq jq curl build-essential libxinerama1 libxcursor1 libxtst6 libxi6 linux-kernel-headers open-vm-tools libpcsclite1
apt-get install -yq linux-headers-$(uname -a | awk '{print $3}')
curl -Ss -f -L -o ./vmware-installer "${WORKSTATION_DOWNLOAD_URL}"
chmod a+x ./vmware-installer
./vmware-installer --eulas-agreed --required
vmware-modconfig --console --install-all
/usr/lib/vmware/bin/vmware-vmx-debug --new-sn "${VMWARE_SN}"

curl -Ssf -o vagrant-vmware-utility.deb "$(curl -Ssf 'https://releases.hashicorp.com/vagrant-vmware-utility/index.json' | jq -r '.versions[[.versions | keys[] | split(".") | map(tonumber)] | sort | .[-1] | map(tostring) | join(".")].builds[].url | select(endswith(".deb"))')"
dpkg -i ./vagrant-vmware-utility.deb

pushd /vagrant

dpkg -i vagrant_*_x86_64.deb
vagrant plugin install ./vagrant-spec.gem
vagrant plugin install vagrant-vmware-desktop
vagrant plugin license vagrant-vmware-desktop /vagrant-home/license-vagrant-vmware-desktop.lic

popd
