class master::configure {

### Add puppet master specific configuration to the basic one
#
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

### Generate ssl certificat required for communication with nodes
#

  exec { "puppet-nonca-master":
    command => "/usr/bin/puppet cert generate puppetmaster01.lascalia.com --dns_alt_names=puppetdb,puppetdb.lascalia.com,puppet,puppet.lascalia.com,puppetmaster01,puppetmaster01.lascalia.com",
    require => [ Package[ "puppetserver", "git" ], Vcsrepo["/etc/puppet/environments" ] ],
    creates => "/var/lib/puppet/ssl/certs/puppetmaster01.lascalia.com.pem",
  }

### Autosign certificates for hosts in our domain stated in the source file

  file { "/etc/puppet/autosign.conf":
    source => "puppet:///modules/master/autosign.conf",
  }

### Hiera configuration file
#
  file { "/etc/hiera.yaml":
    source => "puppet:///modules/master/hiera.yaml",
  }

  file { "/etc/puppet/hiera.yaml":
    ensure => link,
    target => "/etc/hiera.yaml",
  }

### Hiera directory structure - this is provided from git repo, leaving here just in case
#

#  file { "/etc/puppet/environments/production/hieradata/":
#    ensure => directory,
#  }

#  file { "/etc/puppet/environments/production/hieradata/production":
#    ensure => directory,
#  }

#  file { "/etc/puppet/environments/production/hieradata/production":
#    ensure => directory,
#  }

#  file { "/etc/puppet/environments/production/hieradata/production":
#    ensure => directory,
#  }


### Required for puppetdb
#
#  file { "/etc/puppetdb/conf.d/jetty.ini":
#    source => "puppet:///modules/master/jetty.ini",
#  }

#  file { "/etc/puppetdb/ssl":
#    ensure => directory,
#    require => File[ "/etc/puppetdb/conf.d/jetty.ini" ], 
#  }

#  file { "/etc/puppetdb/ssl/jetty.key":
#    source => "puppet:///modules/master/jetty.key", 
#  }

#  file { "/etc/puppetdb/ssl/jetty.crt":
#    source => "puppet:///modules/master/jetty.crt",
#  }

#  file { "/etc/puppetdb/ssl/cacert.pem":
#    source => "puppet:///modules/master/cacert.pem",
#  }

#  service { "puppetdb":
#    ensure => running,
#    require => [ Service[puppetserver], File[ "/etc/puppetdb/conf.d/jetty.ini" ] ],
#  }

}
