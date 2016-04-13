class web {

  $webrpm = [ "php", "php-mysqlnd", "httpd" ]

  package { $webrpm: 
    ensure => latest,
  }

  service { "httpd":
    ensure => running,
  }

}
