node default { }

node 'master' {
  include master
}

node 'web' {
  include web
}

node 'db' {
  include db
}
