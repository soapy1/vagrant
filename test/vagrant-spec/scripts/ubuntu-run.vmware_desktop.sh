#!/bin/bash
set -x

export VAGRANT_EXPERIMENTAL="1"
export VAGRANT_SPEC_BOX="${VAGRANT_SPEC_BOX}"

vagrant plugin list
vmware --version
systemctl start vagrant-vmware-utility


vagrant vagrant-spec ${VAGRANT_SPEC_ARGS} /vagrant/test/vagrant-spec/configs/vagrant-spec.config.vmware_desktop.rb
result=$?

exit $result
