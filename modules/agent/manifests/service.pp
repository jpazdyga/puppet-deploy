class agent::service {

### TODO: This should be changed to local firewall setup instead of stopping it
#
  service { "firewalld":
    ensure => stopped,
  }

### Run the puppet agent
#
  service { "puppet":
    ensure => running,
  }

}
