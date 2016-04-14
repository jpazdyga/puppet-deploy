class agent::puppet-agent {

#  exec { "ipv6-disable":
#    command => "sed -i 's/IPV6INIT=yes/IPV6INIT=no/g' /etc/sysconfig/network-scripts/ifcfg-enp0s3",
#    notify => Service["network"],
#  }
 
#  service { "network":
#    ensure => running,
#  }

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

  file { "/etc/hosts":
    source => "puppet:///modules/agent/hosts",
    group => root,
#    require => Exec["ipv6-disable"],
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
