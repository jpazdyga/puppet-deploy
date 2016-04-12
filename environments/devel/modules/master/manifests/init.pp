package { 'puppetserver':
  ensure => latest,
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

file { '/etc/puppet/auth.conf':
  mode => 0755,
  require => Exec['fetch_auth.conf'],
}
