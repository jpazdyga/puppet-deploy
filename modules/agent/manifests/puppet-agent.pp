class agent::puppet-agent {

  file { "/etc/puppet/puppet.conf":
    source => "puppet:///modules/agent/puppet.conf",
  }

  file { "/etc/hosts":
    source => "puppet:///modules/agent/hosts",
  }

  service { "firewalld":
    ensure => stopped,
  }

}
