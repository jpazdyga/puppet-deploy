class agent {

  anchor { 'agent::begin': } ~>
  class { 'agent::install': } ->
  class { 'agent::configure': } ->
  class { 'agent::service': } ~>
  anchor { 'agent::end': }

}
