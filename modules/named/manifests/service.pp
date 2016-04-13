class named::service {

  service { "named":
    ensure => running,
  }

}
