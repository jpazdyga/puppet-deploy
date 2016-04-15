class web::install {

  $webrpm = [ "php", "php-mysqlnd", "httpd" ]

  package { $webrpm: 
    ensure => latest,
  }

}
