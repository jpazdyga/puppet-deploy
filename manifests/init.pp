### Different configs can be applied here to hosts using it's name
#
node default {
  include agent
}

node "puppetmaster01" {
  include master
}

node /^app(.*)$/ {
  include agent
}

node /^proxy(.*)$/ {
  include agent
}

node /^common(.*)$/ {
  include agent
}

