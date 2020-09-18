Vagrant::Spec::Acceptance.configure do |c|
  c.vagrant_path = "/usr/bin/vagrant"
  # Allow for slow setup to still pass
  c.assert_retries = 15
  c.provider "vmware_desktop", box: ENV["VAGRANT_SPEC_BOX"]
end
