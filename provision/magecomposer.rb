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
    config.vm.box_version = "2.5"
    config.vm.network "private_network", type: "dhcp"
    config.vm.hostname = "#{$hostname}"

    config.vm.synced_folder ".", "#{$vm_path}", :mount_options => ["dmode=777", "fmode=775"]
    config.vm.synced_folder "#{$path_to_scripts}/general", "/home/vagrant/scripts", :mount_options => ["dmode=777", "fmode=775"]
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.box_download_insecure = true

    config.vm.provision "shell", inline: script

    config.trigger.after [:up, :reload] do
        run_remote "bash /home/vagrant/scripts/startup-scotchbox.sh"
        run_remote "sudo composer self-update"
    #    run_remote "cd #{$vm_path} && composer update"
    end
end