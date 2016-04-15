class agent::puppet-agent {

  file { "/etc/facter/":
    ensure => directory,
  }

  file { "/etc/facter/facts.d/":
    ensure => directory,
    require => File[ "/etc/facter/" ],
  }

### Assign the proper puppet.conf. It relies on FQDN, but could be amended according to needs.

  case $fqdn {
    /^puppetmaster01(.*)$/: {
      file { "/etc/puppet/puppet.conf":
        source => "puppet:///modules/agent/prod-puppet.conf",
      }
    }
    /^(.*)bl6p(.*)$/: {
      file { "/etc/puppet/puppet.conf":
        source => "puppet:///modules/agent/prod-puppet.conf",
      }
    }
    /^(.*)bl6q(.*)$/: {
      file { "/etc/puppet/puppet.conf":
        source => "puppet:///modules/agent/qa-puppet.conf",
      }
    }
    /^(.*)bl6d(.*)$/: {
      file { "/etc/puppet/puppet.conf":
        source => "puppet:///modules/agent/qa-puppet.conf",
      }
    }
  }

  case $fqdn {
    /^puppetmaster01(.*)$/: {
      file { "/etc/facter/facts.d/role.txt":
        source => "puppet:///modules/base/role.txt",
      }
    }
    /^app(.*)$/: {
      file { "/etc/facter/facts.d/role.txt":
        source => "puppet:///modules/base/role-app.txt",
      }
    }
    /^proxy(.*)$/: {
      file { "/etc/facter/facts.d/role.txt":
        source => "puppet:///modules/base/role-proxy.txt",
      }
    }
    /^common(.*)$/: {
      file { "/etc/facter/facts.d/role.txt":
        source => "puppet:///modules/base/role-common.txt",
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

  file { "/etc/yum.conf":
    source => "puppet:///modules/agent/yum.conf",
    group => root,
  }

  exec { "update-puppet-agent.conf":
    command => '/usr/bin/sed -i "s/\[main\]/\[main\]\n    confdir = \/etc\/puppet/g" /etc/puppet/puppet.conf',
    unless => "/usr/bin/grep confdir /etc/puppet/puppet.conf",
    require => File["/etc/puppet/puppet.conf"],
  }

  service { "firewalld":
    ensure => stopped,
  }

  service { "puppet":
    ensure => running,
  }

#  exec { "reset-cert":
#    command => '/usr/bin/find /var/lib/puppet/ssl -name puppetmaster01.lascalia.com.pem -delete',
#    notify => Service["puppet"],
#  }
}
