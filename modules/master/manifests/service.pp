class master::service {

### Start the puppet server after certificates been created
#
  service { "puppetserver":
    ensure => running,
    require => Exec["puppet-nonca-master"],
  }


}
