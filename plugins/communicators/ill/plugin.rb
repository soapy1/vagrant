require "vagrant"

module VagrantPlugins
  module CommunicatorIll
    class Plugin < Vagrant.plugin("2")
      name "Ill communicator"
      description <<-DESC
      This plugins is bad it communicating! It does not communicate
      with the guest, even when it says it does
      DESC

      communicator("ill") do
        require File.expand_path("../communicator", __FILE__)
        Communicator
      end
    end
  end
end
