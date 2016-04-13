class named {

  anchor { 'named::begin': } ->
  class { 'named::install': } ->
  class { 'named::configure': } ->
  class { 'named::service': } ->
  anchor { 'named::end': }

}
