script = <<SCRIPT
echo "<VirtualHost *:80>
    UseCanonicalName Off
    DocumentRoot /var/www/public/web

    RewriteEngine On
    RewriteRule ^/d3panel/?$ /wp/d3panel [R=301,L]
    RewriteRule ^/wp-admin/?$ /wp/wp-admin [R=301,L]
    RewriteRule ^/index\.php$ - [L]
    RewriteCond %{DOCUMENT_ROOT}%{REQUEST_FILENAME} !-f
    RewriteCond %{DOCUMENT_ROOT}%{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_URI} !^/php5\.fcgi/*
    RewriteRule . /index.php [L]

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
    config.vm.synced_folder "#{$path_to_scripts}/general", "/home/vagrant/scripts", :mount_options => ["dmode=777", "fmode=775"]
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.box_download_insecure = true

    config.vm.provision "shell", inline: script
    
    config.trigger.after [:up, :reload] do
        run_remote "bash /home/vagrant/scripts/startup-scotchbox.sh"
        run "composer self-update"
        run "composer update"
    end
end