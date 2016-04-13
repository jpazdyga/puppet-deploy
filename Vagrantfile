# -*- mode: ruby -*-
# vi: set ft=ruby :

$shell = <<SHELL
  rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
  yum -y install ruby wget bind-utils puppet augeas hiera
  if [ -z /usr/bin/puppet ]; then ln -s /usr/local/bin/puppet /usr/bin/puppet; fi
SHELL

$options = "--verbose"

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
    vb.memory = 2348
    vb.cpus = 2
  end

  config.vm.provision :shell, inline: $shell

  config.vm.define "master-vm" do |master|
    master.vm.box = "jhcook/centos7"
    master.vm.provision :puppet do |puppet|
      master.vm.hostname = "master-vm"
      master.vm.network :private_network, ip: "10.1.1.10"

#      Puppet version < 4
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "modules"
#      puppet.working_directory = "/puppet-deploy"

#     Puppet version > 4
#      puppet.environment_path = "environments"
#      puppet.environment = "devel"

#     Universal
      puppet.facter = {
        "version" => "1"
      }
      puppet.hiera_config_path = "hiera.yaml"
      puppet.options = $options

      master.vm.network "forwarded_port", guest: 8140, host: 8140
    end
  end

  config.vm.define "web-vm" do |web|
    web.vm.box = "jhcook/centos7"
    web.vm.provision :puppet do |puppet|
      web.vm.hostname = "web-vm"
      web.vm.network :private_network, ip: "10.1.1.11"

#      Puppet version < 4
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "modules"
#      puppet.working_directory = "/puppet-deploy"

#     Puppet version > 4
#      puppet.environment_path = "environments"
#      puppet.environment = "devel"

#     Universal
      puppet.facter = {
        "version" => "1"
      }
      puppet.hiera_config_path = "hiera.yaml"
      puppet.options = $options

      web.vm.network "forwarded_port", guest: 80, host: 10080
    end
  end

  config.vm.define "db-vm" do |db|
    db.vm.box = "jhcook/centos7"
    db.vm.provision :puppet do |puppet|
      db.vm.hostname = "db-vm"
      db.vm.network :private_network, ip: "10.1.1.12"

#      Puppet version < 4
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "modules"
#      puppet.working_directory = "/puppet-deploy"

#     Puppet version > 4
#      puppet.environment_path = "environments"
#      puppet.environment = "devel"

#     Univesal
      puppet.facter = {
        "version" => "1"
      }
      puppet.hiera_config_path = "hiera.yaml"
      puppet.options = $options

      db.vm.network "forwarded_port", guest: 3306, host: 13306
    end
  end
end
