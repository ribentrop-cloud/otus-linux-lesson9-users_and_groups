# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
config.vm.define "vm-lesson9" do |subconfig|
	subconfig.vm.box = "centos/7"
	subconfig.vm.hostname = "vm-lesson9"
	subconfig.vm.network :private_network, ip: "192.168.50.11"
	subconfig.vm.provider "virtualbox" do |vb|
		vb.memory = "1024"
		vb.cpus = "1"
	end
end

# --- Provisioning to add test users ---
config.vm.provision "shell", path: "./add-test-users.sh"

# --- Provisioning to change sshd and pam configs ---
config.vm.provision "shell", path: "./change-configs.sh"


# --- Provisioning to move pam_exec script to appropriate directory ---
config.vm.provision "file", source: "./provisioning_files", destination: "/tmp/provisioning_files"
config.vm.provision "shell",inline: "sudo -s"
config.vm.provision "shell",inline: "cp /tmp/provisioning_files/is-admin.sh /usr/local/bin/is-admin.sh"


# --- Provisioning to change sshd and pam configs ---
#config.vm.provision "shell", path: "./change-configs.sh"

end
