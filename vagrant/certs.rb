# -*- mode: ruby -*-
# vi: set ft=ruby :

# requires vagrant-triggers
# requires vagrant-hostmanager

cert_script = <<SCRIPT

echo "<VirtualHost *:443>
    UseCanonicalName Off
    SSLEngine On
    SSLCertificateFile  /etc/ssl/certs/ssl.crt
    SSLCertificateKeyFile /etc/ssl/private/ssl.key
    DocumentRoot            /var/www/public/
    <Directory /var/www/public/>
        AllowOverride All
    </Directory>
</VirtualHost>" > /etc/apache2/sites-available/certs.conf

sudo a2enmod ssl
sudo a2ensite certs

SCRIPT

Vagrant.configure("2") do |config|
    
    # provision: add datamanager :8999 to apache VHost
    # provision: clone latest version of datamanager
    config.vm.provision "shell", inline: cert_script
    
    config.trigger.after [:up, :reload] do
        run_remote "bash /home/vagrant/scripts/certs.sh; echo 'Certs are setup!'"
    end
end