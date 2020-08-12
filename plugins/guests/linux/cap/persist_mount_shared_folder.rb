require "vagrant/util"

require_relative "../../../synced_folders/unix_mount_helpers"

module VagrantPlugins
  module GuestLinux
    module Cap
      class PersistMountSharedFolder
        extend SyncedFolder::UnixMountHelpers

        # Inserts fstab entry for a set of synced folders. Will fully replace
        # the currently managed group of Vagrant managed entries. Note, passing
        # empty list of folders will just remove entries      
        # 
        # @param [Machine] machine The machine to run the action on
        # @param [Map<String, Map>] A map of folders to add to fstab
        def self.persist_mount_shared_folder(machine, folders)
          if folders.nil?
            self.remove_vagrant_managed_fstab(machine)
            return
          end

          ssh_info = machine.ssh_info          
          export_folders = folders.map { |type, folder|
            folder.map { |name, data|
              data[:owner] ||= ssh_info[:username]
              data[:group] ||= ssh_info[:username]
              guest_path = Shellwords.escape(data[:guestpath])
              mount_options, _, _ = machine.synced_folders.types[type].capability(
                :mount_options, name, guest_path, data)
              mount_options = "#{mount_options},nofail"
              {
                name: name,
                mount_point: guest_path,
                mount_type: type,
                mount_options: mount_options,
              }
            }
          }.flatten.compact


          fstab_entry = Vagrant::Util::TemplateRenderer.render('guests/linux/etc_fstab', folders: export_folders)
          self.remove_vagrant_managed_fstab(machine)
          machine.communicate.sudo("echo '#{fstab_entry}' >> /etc/fstab")
        end

        private

        def self.remove_vagrant_managed_fstab(machine)
          machine.communicate.sudo("sed -i '/\#VAGRANT-BEGIN/,/\#VAGRANT-END/d' /etc/fstab")
        end
      end
    end
  end
end
