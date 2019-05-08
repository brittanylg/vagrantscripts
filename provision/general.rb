
Vagrant.configure("2") do |config|
    config.vm.box = "scotch/box"
    config.vm.box_version = "3.5"
    config.vm.network "private_network", type: "dhcp"
    config.vm.hostname = "#{$hostname}"

    config.vm.synced_folder ".", "#{$vm_path}", :mount_options => ["dmode=777", "fmode=775"]
    config.vm.synced_folder "#{$path_to_scripts}/general", "/home/vagrant/scripts", :mount_options => ["dmode=777", "fmode=775"]
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.box_download_insecure = true

    config.trigger.after [:up, :reload] do |trigger|
        trigger.run_remote = {inline: "bash /home/vagrant/scripts/startup-scotchbox.sh"}
    end
end