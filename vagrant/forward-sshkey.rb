 
#change this to the path to your ssh key

Vagrant.configure("2") do |config|
    config.ssh.forward_agent = true
    #pass ssh key into provisioner
    if Vagrant::Util::Platform.windows?
            if File.exists?($ssh_key_path)
                    # Read local machine's SSH Key
                    ssh_key = File.read($ssh_key_path)
                    # send key contents to provisioner
                    config.vm.provision :shell, :inline => "sudo rm -f ~/.ssh/id_rsa && echo 'Windows-specific: Copying local SSH Key to VM...' && sudo mkdir -p ~/.ssh && sudo echo '#{ssh_key}' > ~/.ssh/id_rsa && sudo chmod 600 ~/.ssh/id_rsa && sudo cp ~/.ssh/id_rsa /root/.ssh/id_rsa", :privileged => false
            else
                    raise Vagrant::Errors::VagrantError.new, "\n\nERROR: SSH Key not found on host machine.\n\n"
            end
    end
end