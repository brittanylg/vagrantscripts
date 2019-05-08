script = <<SCRIPT
echo "<VirtualHost *:80>
    UseCanonicalName Off
    DocumentRoot /var/www/public/web

    DirectoryIndex index.php

    <Directory /var/www/public/web>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

sudo service apache2 restart

SCRIPT

Vagrant.configure("2") do |config|
    config.vm.box = "scotch/box"
    config.vm.box_version = "3.5"
    config.vm.network "private_network", type: "dhcp"
    config.vm.hostname = "#{$hostname}"

    config.vm.synced_folder ".", "#{$vm_path}", :mount_options => ["dmode=777", "fmode=775"]
    config.vm.synced_folder "#{$path_to_scripts}/general", "/home/vagrant/scripts", :mount_options => ["dmode=777", "fmode=775"]
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.box_download_insecure = true

    config.vm.provision "shell", inline: script

    config.trigger.after [:up, :reload] do |trigger|
        trigger.run_remote = {inline: "bash /home/vagrant/scripts/startup-scotchbox.sh"}
        trigger.run_remote = {inline: "sudo composer self-update"}
    #    trigger.run_remote = {inline: "cd #{$vm_path} && composer update"}
    end
end