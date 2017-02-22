script = <<SCRIPT
sudo npm install -g slap@latest
SCRIPT

Vagrant.configure("2") do |config|   
    config.vm.provision "shell", inline: script
end
