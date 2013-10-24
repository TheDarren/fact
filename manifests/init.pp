# Provide arbitrary named facts - cannot match name of facter plugin (from
# module path)
#
#
# Example
#
#       fact { "su_sysadmin0": value => "SunetID" }
#       fact { "su_sysadmin1": value => "SunetID2" }
#       fact { "su_support": value => "IDG" }
#       fact { "su_restricted": value => "true" }
#

define fact (
  $ensure = present,
  $value  = unset
) {
  include fact::setup

  $factsdir = $fact::setup::factsdir

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
            group   => $fact::setup::root_group,
            mode    => '0644',
            require => File[$factsdir],
          }
        }
      }
    }
    default: { crit "Invalid ensure value: ${ensure}." }
  }
}
