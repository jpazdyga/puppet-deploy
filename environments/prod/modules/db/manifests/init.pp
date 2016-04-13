class db {

  $dbrpm = [ "mariadb-server", "mariadb-libs", "mariadb" ]

  package { $dbrpm:
    ensure => latest,
  }

  service { "mariadb":
    ensure => running,
  }
}
