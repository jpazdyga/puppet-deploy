node default {
  include agent::puppet-agent
}

node "puppetmaster01" {
  include master
}
