# -*- mode: ruby -*-
# vi: set ft=ruby :

# requires vagrant-triggers
# requires vagrant-hostmanager

cert_script = <<SCRIPT

sudo openssl req -new -x509 -days 365 -nodes -out /etc/ssl/certs/ssl.crt -keyout /etc/ssl/private/ssl.key -subj "/C=RO/ST=Bucharest/L=Bucharest/O=IT/CN=www.example.ro"

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
sudo service apache2 restart
SCRIPT

Vagrant.configure("2") do |config|
    config.vm.provision "shell", inline: cert_script
end