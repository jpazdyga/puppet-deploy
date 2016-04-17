class master {

  anchor { 'master::begin': } ~>
  class { 'master::install': } ->
  class { 'master::configure': } ->
  class { 'master::service': } ~>
  anchor { 'master::end': }

}
