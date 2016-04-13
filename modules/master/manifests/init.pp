class master {

  include agent::puppet-agent

  package { "puppetserver":
    ensure => latest,
    provider => yum,
  }

  package { "git-all":
    ensure => latest,
    provider => yum,
    require => Exec["install-vcsrepo"],
  }

  exec { "update-puppet.conf":
#    command => '/usr/bin/sed -i "s/\[main\]/\[main\]\n    dns_alt_names = puppet,puppet.example.com,puppetmaster01,puppetmaster01.example.com/g" /etc/puppet/puppet.conf',
    command => '/usr/bin/sed -i "s/\[main\]/\[main\]\n    strict_variables = true/g" /etc/puppet/puppet.conf',
    unless => "/usr/bin/grep dns_alt_names /etc/puppet/puppet.conf",
    require => File["/etc/puppet/puppet.conf"],
  }

  exec { "update-puppet.conf-1":
    command => '/usr/bin/echo -e "\n[master]\n    dns_alt_names = puppetmaster01,puppetmaster01.lascalia.com,puppet,puppet.lascalia.com\n    reports = puppetdb\n    storeconfigs_backend = puppetdb\n    storeconfigs = true\n    environment_timeout = unlimited" >> /etc/puppet/puppet.conf',
    unless => "/usr/bin/grep dns_alt_names /etc/puppet/puppet.conf",
    require => Exec["update-puppet.conf"],
  }

  exec { "puppet-nonca-master":
    command => "/usr/bin/puppet cert generate puppetmaster01.lascalia.com --dns_alt_names=puppet,puppet.lascalia.com,puppetmaster01,puppetmaster01.lascalia.com",
    require => Package["puppetserver"],
    creates => "/var/lib/puppet/ssl/certs/puppetmaster01.lascalia.com",
  }

  file { "/etc/puppet/autosign.conf":
    source => "puppet:///modules/master/autosign.conf",
  }

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

#  exec { "revoke-cert":
#    command => "/usr/bin/puppet cert clean puppetmaster01.lascalia.com",
#    require => Service["puppetserver"],
#  }

  include named

}
