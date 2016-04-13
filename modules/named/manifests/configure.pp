class named::configure {

  file { "/etc/named.conf":
    source => "puppet:///modules/named/named.conf",
    group => named,
    mode => 640,
  }

  file { "/var/named/lascalia.com.zone":
    source => "puppet:///modules/named/lascalia.com.zone",
    group => named,
    mode => 640,
  }

  file { "/var/named/1.1.10.zone":
    source => "puppet:///modules/named/1.1.10.zone",
    group => named,
    mode => 640,
  }

  file { "/var/named/2.1.10.zone":
    source => "puppet:///modules/named/2.1.10.zone",
    group => named,
    mode => 640,
  }

  file { "/var/named/3.1.10.zone":
    source => "puppet:///modules/named/3.1.10.zone",
    group => named,
    mode => 640,
  }

}
