class master {

  include agent::puppet-agent

  $masterrpms = [ "puppetserver", "puppetdb", "puppetdb-terminus"]

  package { $masterrpms:
    ensure => latest,
    provider => yum,
    require => File["/etc/yum.conf"],
  }

  package { "git-all":
    ensure => latest,
    provider => yum,
    require => Exec["install-vcsrepo"],
  }

  exec { "update-puppet.conf":
    command => '/usr/bin/sed -i "s/\[main\]/\[main\]\n    confdir = \/etc\/puppet\n    environmentpath = \$confdir\/environments\n    strict_variables = true\n    certname = puppetmaster01.lascalia.com/g" /etc/puppet/puppet.conf',
    unless => "/usr/bin/grep environmentpath /etc/puppet/puppet.conf",
    require => File["/etc/puppet/puppet.conf"],
  }

  exec { "update-puppet.conf-1":
    command => '/usr/bin/echo -e "\n[master]\n    dns_alt_names = puppetmaster01.lascalia.com\n#    reports = puppetdb\n#    storeconfigs_backend = puppetdb\n#    storeconfigs = true\n    environment_timeout = unlimited" >> /etc/puppet/puppet.conf',
    unless => "/usr/bin/grep dns_alt_names /etc/puppet/puppet.conf",
    require => Exec["update-puppet.conf"],
  }

#  exec { "update-puppet.conf-2":
#    command => '/usr/bin/echo -e "\n\n[prod]\n  manifest = /etc/puppet/environments/prod/manifests/site.pp\n  modulepath = /etc/puppet/environments/prod/modules\n  hieradata = /etc/puppet/environments/prod/hieradata\n[qa]\n  manifest = /etc/puppet/environments/qa/manifests/site.pp\n  modulepath = /etc/puppet/environments/qa/modules\n  hieradata = /etc/puppet/environments/qa/hieradata\n[dev]\n  manifest = /etc/puppet/environments/dev/manifests/site.pp\n  modulepath = /etc/puppet/environments/dev/modules\n  hieradata = /etc/puppet/environments/dev/hieradata" >> /etc/puppet/puppet.conf',
#    unless => '/usr/bin/grep "environments/qa" /etc/puppet/puppet.conf',
#    require => Exec["update-puppet.conf-1"],
#  }

  exec { "puppet-nonca-master":
    command => "/usr/bin/puppet cert generate puppetmaster01.lascalia.com --dns_alt_names=puppetdb,puppetdb.lascalia.com,puppet,puppet.lascalia.com,puppetmaster01,puppetmaster01.lascalia.com",
    require => [ Package[ "puppetserver", "git-all" ], Vcsrepo["/etc/puppet/environments" ] ],
    creates => "/var/lib/puppet/ssl/certs/puppetmaster01.lascalia.com.pem",
  }

  file { "/etc/puppet/autosign.conf":
    source => "puppet:///modules/master/autosign.conf",
  }

#  file { "/etc/puppetdb/conf.d/jetty.ini":
#    source => "puppet:///modules/master/jetty.ini",
#  }

#  file { "/etc/puppetdb/ssl":
#    ensure => directory,
#    require => File[ "/etc/puppetdb/conf.d/jetty.ini" ], 
#  }

  file { "/etc/hiera.yaml":
    source => "puppet:///modules/master/hiera.yaml",
  }

#  file { "/etc/puppetdb/ssl/jetty.key":
#    source => "puppet:///modules/master/jetty.key", 
#  }

#  file { "/etc/puppetdb/ssl/jetty.crt":
#    source => "puppet:///modules/master/jetty.crt",
#  }

#  file { "/etc/puppetdb/ssl/cacert.pem":
#    source => "puppet:///modules/master/cacert.pem",
#  }

#  exec { "puppet-nonca-master":
#    command => "/usr/bin/puppet master --verbose",
#    require => Package["puppetserver"],
#    creates => "/var/lib/puppet/ssl/certs/puppetmaster01.lascalia.com.pem",
#  }

  exec { "install-vcsrepo":
    path => "/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/vagrant/.local/bin:/home/vagrant/bin",
    command => '/usr/bin/puppet module install puppetlabs/vcsrepo',
    creates => "/etc/puppet/modules/vcsrepo",
  }

  vcsrepo { "/etc/puppet/environments":
    ensure => present,
    provider => git,
    source => "https://github.com/jpazdyga/puppet-environments.git",
    require => Exec["install-vcsrepo"],
  }

  service { "puppetserver":
    ensure => running,
    require => Exec["puppet-nonca-master"],
#    require => Package["puppetserver"],
  }

#  service { "puppetdb":
#    ensure => running,
#    require => [ Service[puppetserver], File[ "/etc/puppetdb/conf.d/jetty.ini" ] ],
#  }

#  exec { "revoke-cert":
#    command => "/usr/bin/puppet cert clean puppetmaster01.lascalia.com",
#    require => Service["puppetserver"],
#  }

  include named

}
