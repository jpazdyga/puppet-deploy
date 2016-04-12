package { 'puppet':
  ensure => latest,
  provider => gem,
}

#ln -s /usr/lib64/ruby/gems/2.1.0/gems/puppet-4.4.1/bin/puppet /usr/bin/puppet
file { '/usr/bin/puppet':
  ensure => link,
  target => /usr/lib64/ruby/gems/2.1.0/gems/puppet-4.4.1/bin/puppet,
}

group { 'puppet':
  name => puppet,
  ensure => present,
}

user { 'puppet':
  name => puppet,
  ensure => present,
  gid => puppet,
  shell => /sbin/nologin,
}

file { '/etc/puppet':
  ensure => directory,
}

file { '/etc/puppet/puppet.conf':
  ensure => present, 
}

exec { 'fetch_auth.conf':
  command => 'wget https://raw.githubusercontent.com/puppetlabs/puppet/3.7.5/conf/auth.conf -O /etc/puppet/auth.conf',
  creates => /etc/puppet/auth.conf,
}

file { '/etc/puppet/auth.conf':
  mode => 0755,
  require => Exec['fetch_auth.conf'],
}
