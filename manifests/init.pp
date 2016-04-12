node default {
  include agent::puppet-agent
}

node 'master-vm' {
  include master
}

node 'web-vm' {
  include web
}

node 'db-vm' {
  include agent::puppet-agent
  include db
}
