# -*- mode: ruby -*-
# vi: set ft=ruby :

$shell = <<SHELL
  rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
  yum -y install ruby wget bind-utils puppet augeas hiera
  if [ -z /usr/bin/puppet ]; then ln -s /usr/local/bin/puppet /usr/bin/puppet; fi
SHELL

$options = "--verbose --debug"

Vagrant.configure(2) do |config|
  config.vm.box_check_update = false

  # config.vm.synced_folder "./puppet-deploy", "/puppet-deploy"

  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.memory = 2348
    vb.cpus = 2
  end

  config.vm.provision :shell, inline: $shell

  config.vm.define "puppetmaster01" do |master|
    master.vm.box = "jhcook/centos7"
    master.vm.provision :puppet do |puppet|
      master.vm.hostname = "puppetmaster01"
      master.vm.network :private_network, ip: "10.1.1.10"

      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "modules"
      puppet.facter = {
        "version" => "1"
      }
      puppet.hiera_config_path = "hiera.yaml"
      puppet.options = $options

      master.vm.network "forwarded_port", guest: 8140, host: 8140
    end
  end

  config.vm.define "prod01-web01" do |web|
    web.vm.box = "jhcook/centos7"
    web.vm.provision :puppet do |puppet|
      web.vm.hostname = "prod01-web01"
      web.vm.network :private_network, ip: "10.1.1.11"

      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "modules"
      puppet.facter = {
        "version" => "1"
      }
      puppet.hiera_config_path = "hiera.yaml"
      puppet.options = $options

      web.vm.network "forwarded_port", guest: 80, host: 10080
    end
  end

  config.vm.define "prod01-db01" do |db|
    db.vm.box = "jhcook/centos7"
    db.vm.provision :puppet do |puppet|
      db.vm.hostname = "prod01-db01"
      db.vm.network :private_network, ip: "10.1.1.12"

      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "modules"
      puppet.facter = {
        "version" => "1"
      }
      puppet.hiera_config_path = "hiera.yaml"
      puppet.options = $options

      db.vm.network "forwarded_port", guest: 3306, host: 13306
    end
  end

  config.vm.define "qa01-web01" do |web|
    web.vm.box = "jhcook/centos7"
    web.vm.provision :puppet do |puppet|
      web.vm.hostname = "qa01-web01"
      web.vm.network :private_network, ip: "10.1.2.11"

      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "modules"
      puppet.facter = {
        "version" => "1"
      }
      puppet.hiera_config_path = "hiera.yaml"
      puppet.options = $options

      web.vm.network "forwarded_port", guest: 80, host: 20080
    end
  end

  config.vm.define "qa01-db01" do |db|
    db.vm.box = "jhcook/centos7"
    db.vm.provision :puppet do |puppet|
      db.vm.hostname = "qa01-db01"
      db.vm.network :private_network, ip: "10.1.2.12"

      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "modules"
      puppet.facter = {
        "version" => "1"
      }
      puppet.hiera_config_path = "hiera.yaml"
      puppet.options = $options

      db.vm.network "forwarded_port", guest: 3306, host: 23306
    end
  end

  config.vm.define "dev01-web01" do |web|
    web.vm.box = "jhcook/centos7"
    web.vm.provision :puppet do |puppet|
      web.vm.hostname = "dev01-web01"
      web.vm.network :private_network, ip: "10.1.3.11"

      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "modules"
      puppet.facter = {
        "version" => "1"
      }
      puppet.hiera_config_path = "hiera.yaml"
      puppet.options = $options

      web.vm.network "forwarded_port", guest: 80, host: 30080
    end
  end

  config.vm.define "dev01-db01" do |db|
    db.vm.box = "jhcook/centos7"
    db.vm.provision :puppet do |puppet|
      db.vm.hostname = "dev01-db01"
      db.vm.network :private_network, ip: "10.1.3.12"

      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "modules"
      puppet.facter = {
        "version" => "1"
      }
      puppet.hiera_config_path = "hiera.yaml"
      puppet.options = $options

      db.vm.network "forwarded_port", guest: 3306, host: 33306
    end
  end
end
