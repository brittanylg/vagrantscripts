# -*- mode: ruby -*-
# vi: set ft=ruby :
# requires vagrant-triggers
# requires vagrant-hostmanager
$script = <<SCRIPT

sudo apt-get purge --assume-yes mysql-server mysql-server-5.5 mysql-server-core-5.5 mysql-client mysql-client-5.5 mysql-client-core-5.5
sudo apt-get -y update
export DEBIAN_FRONTEND="noninteractive"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get install --assume-yes mysql-server-5.6 mysql-client-5.6
export DEBIAN_FRONTEND="interactive"

SCRIPT


Vagrant.configure("2") do |config|   
    config.vm.provision "shell", inline: $script, privileged: false
end