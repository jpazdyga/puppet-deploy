node default { }

node 'master-vm' {
  include master
}

node 'web-vm' {
  include web
}

node 'db-vm' {
  include db
}
