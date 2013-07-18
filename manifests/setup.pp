class fact::setup {
  $factsdir = "${::puppet_vardir}/sufact"

  $root_group = $id ? {
    root    => 0,
    default => $id
  }

  file { $factsdir:
    ensure => directory,
    group  => $root_group,
    mode   => '0750',
    owner  => $::id,
  }
}
