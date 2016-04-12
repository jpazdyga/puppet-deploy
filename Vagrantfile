# -*- mode: ruby -*-
# vi: set ft=ruby :


$shell = <<SHELL
  sudo wget https://www.virtualbox.org/download/testcase/VBoxGuestAdditions_5.0.17-106140.iso -O /mnt/VBoxGuestAdditions_5.0.17-106140.iso
  sudo install linux-headers-$(uname -r) build-essential dkms
  sudo mkdir /media/VBoxGuestAdditions
  sudo mount -o loop,ro /mnt/VBoxGuestAdditions_5.0.17-106140.iso /media/VBoxGuestAdditions
  sudo sh /media/cdrom/VBoxLinuxAdditions.run --nox11
  sudo /etc/init.d/vboxadd setup
  sudo chkconfig --add vboxadd
  sudo chkconfig vboxadd on
  sudo umount /media/VBoxGuestAdditions
  sudo rmdir /media/VBoxGuestAdditions
SHELL


Vagrant.configure(2) do |config|
  config.vm.box_check_update = false

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"
  # config.vm.synced_folder "./puppet-deploy", "/puppet-deploy"

  # Use one key for all vms so ansible can connect to them
  config.ssh.insert_key = false

  # Need to disable vbguest updating for this  box as it has an old kernel so vbguest won't compile
  #if Vagrant.has_plugin?("vbguest") or Vagrant.has_plugin?("vagrant-vbguest")
  #  config.vbguest.auto_update = false
  #end

  config.vm.provider :virtualbox do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of memory on the VM:
    vb.memory = 1024
    vb.cpus = 1
  end

  config.vm.provision :shell, inline: $shell

  config.vm.define "master-vm" do |master|
    master.vm.box = "centos/7"
    master.vm.provision :puppet do |puppet|
      master.vm.hostname = "master-vm"
      master.vm.network :private_network, ip: "10.1.1.10"

      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "modules"
      puppet.facter = {
        "version" => "1"
      }
      puppet.hiera_config_path = "hiera.yaml"
      puppet.working_directory = "/puppet-deploy"
      puppet.options = "--verbose"

    end
  end

  config.vm.define "web-vm" do |web|
    web.vm.box = "centos/7"
    web.vm.provision :puppet do |puppet|
      web.vm.hostname = "web-vm"
      web.vm.network :private_network, ip: "10.1.1.11"

      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "modules"
      puppet.facter = {
        "version" => "1"
      }
      puppet.hiera_config_path = "hiera.yaml"
      puppet.working_directory = "/puppet-deploy"
      puppet.options = "--verbose"

      web.vm.network "forwarded_port", guest: 80, host: 1080
    end
  end

  config.vm.define "db-vm" do |db|
    db.vm.box = "centos/7"
    db.vm.provision :puppet do |puppet|
      db.vm.hostname = "db-vm"
      db.vm.network :private_network, ip: "10.1.1.12"

      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "modules"
      puppet.facter = {
        "version" => "1"
      }
      puppet.hiera_config_path = "hiera.yaml"
      puppet.working_directory = "/puppet-deploy"
      puppet.options = "--verbose"

      db.vm.network "forwarded_port", guest: 3306, host: 13306
    end
  end
end
