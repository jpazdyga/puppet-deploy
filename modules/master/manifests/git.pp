class master::git {

  vcsrepo { "/etc/puppet/environments":
    ensure => present,
    provider => git,
    source => "https://github.com/jpazdyga/puppet-environments.git",
    require => Exec["vcsrepo-install"],
  }

}
