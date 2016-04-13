class master {

  package { "puppetserver":
    ensure => latest,
    provider => yum,
  }

  package { "git-all":
    ensure => latest,
    provider => yum,
    require => Exec["install-vcsrepo"],
  }

  exec { "puppet-nonca-master":
    command => "/usr/bin/puppet cert generate puppetmaster01 --dns_alt_names=puppet,puppet.lascalia.com,puppetmaster01,puppetmaster01.lascalia.com",
    require => Package["puppetserver"],
    creates => "/var/lib/puppet/ssl/certs/puppetmaster01.pem",
  }

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
  }

  service { "firewalld":
    ensure => stopped,
  }

  exec { "revoke-cert":
    command => "puppet cert clean puppetmaster01.lascalia.com",
    require => Service["puppetserver"],
  }
}
