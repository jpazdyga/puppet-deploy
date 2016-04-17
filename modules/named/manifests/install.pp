class named::install {

### Install required rpms
#
  $dnsserver = [ "bind-utils", "bind-libs", "bind-chroot", "bind" ]

  package { $dnsserver:
    ensure => latest,
  }

}
