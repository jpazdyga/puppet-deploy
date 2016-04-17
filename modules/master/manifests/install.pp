class master::install {


### Deploy basic puppet config
#
  include agent

### This is required for puppetdb, not doing that this time. As we are not deploing puppetdb for now, we'll use only puppetserver.
#
#  $masterrpms = [ "puppetserver", "puppetdb", "puppetdb-terminus"]

  $masterrpms = [ "puppetserver" ]

  package { $masterrpms:
    ensure => latest,
    provider => yum,
    require => File["/etc/yum.conf"],
  }

### This is required to pull the puppet code to be distributed when whole environment will be set up
#
  package { "git":
    ensure => latest,
    provider => yum,
    require => Exec["install-vcsrepo"],
  }

### Install vcs module, required to use pull and push from control version systems
#
  exec { "install-vcsrepo":
    path => "/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/vagrant/.local/bin:/home/vagrant/bin",
    command => '/usr/bin/puppet module install puppetlabs/vcsrepo',
    creates => "/etc/puppet/modules/vcsrepo",
  }

### Clone the puppet code from the git repo
#
  vcsrepo { "/etc/puppet/environments":
    ensure => present,
    provider => git,
    source => "https://github.com/jpazdyga/puppet-environments.git",
    require => Exec["install-vcsrepo"],
  }

### Deploy DNS server to puppet master ###
#
  include named

}
