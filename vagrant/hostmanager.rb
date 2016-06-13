 
# -*- mode: ruby -*-
# vi: set ft=ruby :

# requires vagrant-triggers
# requires vagrant-hostmanager

Vagrant.configure("2") do |config|
    config.hostmanager.enabled = false
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

    cached_addresses = {}
    config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
        if cached_addresses[vm.name].nil?
        if hostname = (vm.ssh_info && vm.ssh_info[:host])
            vm.communicate.execute("/sbin/ifconfig eth1 | grep 'inet addr' | tail -n 1 | egrep -o '[0-9\.]+' | head -n 1 2>&1") do |type, contents|
            cached_addresses[vm.name] = contents.split("\n").first[/(\d+\.\d+\.\d+\.\d+)/, 1]
            end
        end
        end
        cached_addresses[vm.name]
    end
    
    config.trigger.after [:up, :reload] do
        run "vagrant hostmanager"
    end
end