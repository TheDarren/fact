class fact::setup(
  $facterdir = '/etc/facter'
) {
  $factsdir = "${facterdir}/facts.d"

  $root_group = $::id ? {
    root    => 0,
    default => $::id
  }

  file { $facterdir:
    ensure => directory,
    owner  => $::id,
    group  => $root_group,
    mode   => '0755',
  }

  file { $factsdir:
    ensure => directory,
    purge  => true,
    owner  => $::id,
    group  => $root_group,
    mode   => '0755',
  }
}
