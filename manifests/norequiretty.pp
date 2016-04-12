augeas { "sudoers":
  context => "/files/etc/sudoers",
  changes => [
    "Defaults:vagrant !requiretty",
  ],
}
