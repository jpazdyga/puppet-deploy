class web::service {

  service { "httpd":
    ensure => running,
  }

}
