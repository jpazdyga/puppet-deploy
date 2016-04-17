class agent::configure {

### Make sure that facter dirs are in place
#

  file { "/etc/facter/":
    ensure => directory,
  }

  file { "/etc/facter/facts.d/":
    ensure => directory,
    require => File[ "/etc/facter/" ],
  }

### Assign the proper puppet.conf. It relies on FQDN, but could be amended according to needs.
#
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

### Set initial role fact. This is used only once.
#

  case $fqdn {
    /^puppetmaster01(.*)$/: {
      file { "/etc/facter/facts.d/role.txt":
        source => "puppet:///modules/agent/role.txt",
      }
    }
    /^app(.*)$/: {
      file { "/etc/facter/facts.d/role.txt":
        source => "puppet:///modules/agent/role-app.txt",
      }
    }
    /^proxy(.*)$/: {
      file { "/etc/facter/facts.d/role.txt":
        source => "puppet:///modules/agent/role-proxy.txt",
      }
    }
    /^common(.*)$/: {
      file { "/etc/facter/facts.d/role.txt":
        source => "puppet:///modules/agent/role-common.txt",
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

### Using it as workaround when rpm repos mirror lookup fails
#

  file { "/etc/yum.conf":
    source => "puppet:///modules/agent/yum.conf",
    group => root,
  }

### Add $confdir variable to puppet.conf, unless it's already there
#
  exec { "update-puppet-agent.conf":
    command => '/usr/bin/sed -i "s/\[main\]/\[main\]\n    confdir = \/etc\/puppet/g" /etc/puppet/puppet.conf',
    unless => "/usr/bin/grep confdir /etc/puppet/puppet.conf",
    require => File["/etc/puppet/puppet.conf"],
  }

### Can be used to revoke the node certificate
#
#  exec { "reset-cert":
#    command => '/usr/bin/find /var/lib/puppet/ssl -name puppetmaster01.lascalia.com.pem -delete',
#    notify => Service["puppet"],
#  }
}
