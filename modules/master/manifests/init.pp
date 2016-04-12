class master {

  package { "puppetserver":
    ensure => latest,
    provider => yum,
  }

  exec { "puppet-nonca-master":
    command => "/usr/bin/puppet cert generate puppetmaster01 --dns_alt_names=puppet,puppet.lascalia.com,puppetmaster01,puppetmaster01.lascalia.com",
    require => Package["puppetserver"],
    creates => "/var/lib/puppet/ssl/certs/puppetmaster01.pem",
  }

  service { "puppetserver":
    ensure => running,
    require => Exec["puppet-nonca-master"],
  }

  service { "firewalld":
    ensure => stopped,
  }

  file { "/etc/puppet/manifests/site.pp":
    source => "puppet:///modules/master/site.pp",
  }
}
