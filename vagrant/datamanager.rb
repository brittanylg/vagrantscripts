# -*- mode: ruby -*-
# vi: set ft=ruby :

# requires vagrant-triggers
# requires vagrant-hostmanager

script = <<SCRIPT
mkdir -p -m0775 /var/www/mddd
cd /var/www/mddd

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    git init
    git remote add origin https://github.com/dwalkr/mddd.git
    git fetch
    git checkout -t origin/master
else
    git pull
fi

sudo chmod 0775 /var/www/mddd/config


cd ~

echo "Listen 8999
<VirtualHost *:8999>
    UseCanonicalName Off
    DocumentRoot /var/www/mddd
    <Directory /var/www/mddd>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>" > /etc/apache2/sites-available/mddd.conf

sudo a2ensite mddd
sudo service apache2 restart

SCRIPT

Vagrant.configure("2") do |config|
    
    # provision: add datamanager :8999 to apache VHost
    # provision: clone latest version of datamanager
    config.vm.provision "shell", inline: script
    
    config.trigger.after [:up, :reload] do
        run_remote "echo 'Magnificent Downstream Data Dumper is alive and well on port :8999'"
    end
end