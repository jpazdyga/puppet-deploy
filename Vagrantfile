# -*- mode: ruby -*-
# vi: set ft=ruby :

$shell = <<SHELL
  sed -i 's/enforcing/permissive/g' /etc/selinux/config
  setenforce 0
  cp -f /puppet-deploy/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
  rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
  yum -y install ruby wget bind-utils puppet augeas hiera
  if [ -z /usr/bin/puppet ]; then ln -s /usr/local/bin/puppet /usr/bin/puppet; fi
SHELL

$options = "--verbose --debug"

Vagrant.configure(2) do |config|
  config.vm.box_check_update = false
  # config.vm.network "public_network"
  config.vm.synced_folder "./puppet-deploy", "/puppet-deploy"

  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.memory = 3072
    vb.cpus = 2
  end

  config.vm.provision :shell, inline: $shell

  config.vm.define "puppetmaster01" do |master|

    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "6144"]
      vb.customize ["modifyvm", :id, "--cpus", "4"]
    end

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

  config.vm.define "appbl6p" do |web|
    web.vm.box = "jhcook/centos7"
    web.vm.provision :puppet do |puppet|
      web.vm.hostname = "appbl6p"
      web.vm.network :private_network, ip: "10.1.1.11"

      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.module_path = "modules"
      puppet.facter = {
        "version" => "1"
      }
      puppet.hiera_config_path = "hiera.yaml"
      puppet.options = $options

      web.vm.network "forwarded_port", guest: 8088, host: 18088
    end
  end

#  config.vm.define "proxybl6p" do |proxy|
#    proxy.vm.box = "jhcook/centos7"
#    proxy.vm.provision :puppet do |puppet|
#      proxy.vm.hostname = "proxybl6p"
#      proxy.vm.network :private_network, ip: "10.1.1.12"
#
#      puppet.manifests_path = "manifests"
#      puppet.manifest_file = "init.pp"
#      puppet.module_path = "modules"
#      puppet.facter = {
#        "version" => "1"
#      }
#      puppet.hiera_config_path = "hiera.yaml"
#      puppet.options = $options
#
#      proxy.vm.network "forwarded_port", guest: 3128, host: 13128
#    end
#  end

#  config.vm.define "commonbl6p" do |db|
#    db.vm.box = "jhcook/centos7"
#    db.vm.provision :puppet do |puppet|
#      db.vm.hostname = "commonbl6p"
#      db.vm.network :private_network, ip: "10.1.1.13"
#
#      puppet.manifests_path = "manifests"
#      puppet.manifest_file = "init.pp"
#      puppet.module_path = "modules"
#      puppet.facter = {
#        "version" => "1"
#      }
#      puppet.hiera_config_path = "hiera.yaml"
#      puppet.options = $options
#
#      db.vm.network "forwarded_port", guest: 3306, host: 13306
#    end
#  end
end
