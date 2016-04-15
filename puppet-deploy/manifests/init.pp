class web {

  anchor { 'web::begin': } ->
  class { 'web::install': } ->
  class { 'web::configure': } ->
  class { 'web::service': } ->
  anchor { 'web::end': }

}
