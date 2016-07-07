 $script = <<SCRIPT
echo "<VirtualHost *:80>
    UseCanonicalName Off
    DocumentRoot /var/www/public/web
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
    config.vm.network "private_network", type: "dhcp"
    config.vm.hostname = "#{$hostname}"
    
    config.vm.synced_folder ".", "#{$vm_path}", :mount_options => ["dmode=777", "fmode=775"]
    config.vm.synced_folder "#{$path_to_scripts}", "/home/vagrant/scripts", :mount_options => ["dmode=777", "fmode=775"]
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.box_download_insecure = true
    
    config.trigger.after [:up, :reload] do
        run_remote "bash /home/vagrant/scripts/startup-scotchbox.sh"
        run "composer self-update"
        run "composer update"
    end
end