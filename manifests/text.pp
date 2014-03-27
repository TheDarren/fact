# Example
#
#       fact::text { "su_sysadmin0": value => "SunetID" }
#       fact::text { "su_sysadmin1": value => "SunetID2" }
#       fact::text { "su_support": value => "IDG" }
#       fact::text { "su_restricted": value => "true" }
#

define fact::text (
  $ensure = present,
  $value  = undef
) {
  include fact

  $factsdir = $fact::factsdir

  $filepath = "${factsdir}/${name}.txt"

  validate_string($value)

  case $ensure {
    absent: {
      file { $filepath: ensure => absent }
    }
    present: {
      case $value {
        'NOSRC': {
          fail 'value required for fact define'
        }
        default: {
          file { $filepath:
            content => inline_template('<%= @name %>=<%= @value %>'),
            owner   => $::id,
            group   => $fact::root_group,
            mode    => '0644',
            require => File[$factsdir],
          }
        }
      }
    }
    default: { crit "Invalid ensure value: ${ensure}." }
  }
}
