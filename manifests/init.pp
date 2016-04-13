node default {
  include agent::puppet-agent
}

node "puppetmaster01" {
  include master
}

node "prod01-web01" {
  include agent::puppet-agent
}
