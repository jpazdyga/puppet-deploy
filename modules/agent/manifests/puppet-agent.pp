class agent::puppet-agent {

  case $fqdn {
    /^puppetmaster01(.*)$/: {
      file { "/etc/puppet/puppet.conf":
        source => "puppet:///modules/agent/prod-puppet.conf",
      }
    }
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

  file { "/etc/resolv.conf":
    source => "puppet:///modules/agent/resolv.conf",
    group => root,
  }

  service { "firewalld":
    ensure => stopped,
  }

  service { "puppet":
    ensure => running,
  }

  exec { "reset-cert":
    command => '/usr/bin/find /var/lib/puppet/ssl -name puppetmaster01.lascalia.com.pem -delete',
    notify => Service["puppet"],
  }
}
