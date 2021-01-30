# -*- mode: ruby -*-
# vi: set ft=ruby :


# Requires vagrant-host-shell and vagrant-vbguest
required_plugins = %w( vagrant-host-shell vagrant-sshfs )#vagrant-vbguest )
required_plugins.each do |plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

VAGRANTFILE_API_VERSION = "2"

DEFAULT_MEM = 1024
DEFAULT_CPU = 1

#Vagrant.require_version with 1.8
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = 'ubuntu/focal64'

  config.vm.provider 'virtualbox' do |v|
    v.linked_clone = true
  end

  config.ssh.insert_key = false
#   config.vm.synced_folder ".", "/vagrant", type: "virtualbox", disabled: false

  config.vm.define "sandbox" do |sandbox|
    sandbox.vm.hostname = "sandbox"
    sandbox.vm.provider "virtualbox" do |v|
      v.memory = DEFAULT_MEM
      v.cpus = DEFAULT_CPU
      # Display the VirtualBox GUI when booting the machine
#       v.gui = true
      v.customize ["modifyvm", :id, "--vram", "32"]
    end

    config.vm.provision "shell", run: "always", inline: <<-SHELL
        sudo apt-get -y update
        sudo apt-get -y upgrade
        sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
        sudo service ssh restart
        # Fix DNS resolution for .atom2.local
        sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

        sudo apt-get install -y jq
    SHELL
  end
end
