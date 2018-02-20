# -*- mode: ruby -*-
# vi: set ft=ruby :

# requires vagrant-triggers
# requires vagrant-hostmanager

script = <<SCRIPT

cd ~
sudo rm -rf Ioncube-Autoinstall
git clone https://github.com/dwalkr/Ioncube-Autoinstall
sudo chmod +x Ioncube-Autoinstall/eng_ioncube.sh
sudo ./Ioncube-Autoinstall/eng_ioncube.sh

SCRIPT

Vagrant.configure("2") do |config|   
    config.vm.provision "shell", inline: script
end