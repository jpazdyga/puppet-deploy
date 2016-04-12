class master {

  package { "puppetserver":
    ensure => latest,
    provider => yum,
  }

  exec { "puppet-nonca-master":
    command => "/usr/bin/puppet cert generate puppetmaster01 --dns_alt_names=puppet,puppet.lascalia.com,puppetmaster01,puppetmaster01.lascalia.com",
  }

  service { "puppetserver":
    ensure => running,
    require => Exec["puppet-ca-master"],
  }

}
