class named::service {

### Start the configured named service
#
  service { "named":
    ensure => running,
  }

}
