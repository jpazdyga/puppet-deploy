class agent::puppet-agent {

  case $fqdn {
    /^prod01(.*)$/: {
      file { "/etc/puppet/puppet.conf":
        source => "puppet:///modules/agent/prod-puppet.conf",
      }
    }
    /^qa01(.*)$/: {
      file { "/etc/puppet/puppet.conf":
        source => "puppet:///modules/agent/qa-puppet.conf",
      }
    }
    /^dev01(.*)$/: {
      file { "/etc/puppet/puppet.conf":
        source => "puppet:///modules/agent/qa-puppet.conf",
      }
    }
  }

  file { "/etc/hosts":
    source => "puppet:///modules/agent/hosts",
    group => root,
  }

  service { "firewalld":
    ensure => stopped,
  }

  service { "puppet-agent":
    ensure => running,
  }

  exec { "reset-cert":
    exec => "find /var/lib/puppet/ssl -name puppetmaster01.lascalia.com.pem -delete",
    notify => Service["puppet-agent"],
  }
}
