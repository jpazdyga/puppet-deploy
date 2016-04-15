node default {
  include agent::puppet-agent
}

node "puppetmaster01" {
  include master
}

node /^app(.*)$/ {
  include agent::puppet-agent
}

node /^proxy(.*)$/ {
  include agent::puppet-agent
}

node /^common(.*)$/ {
  include agent::puppet-agent
}

