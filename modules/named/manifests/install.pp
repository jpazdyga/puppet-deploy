class named::install {

  $dnsserver = [ "bind-utils", "bind-libs", "bind-chroot", "bind" ]

  package { $dnsserver:
    ensure => latest,
  }

}
