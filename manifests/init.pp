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
  $ensure=present,
  $value='NOSRC'
) {
  include fact::setup

  $factsdir = $fact::setup::factsdir

  case $ensure {
    absent: {
      file { "${factsdir}/${name}": ensure => absent }
    }
    present: {
      case $value {
        'NOSRC': {
          fail 'value required for fact define'
        }
        default: {
          file { "${factsdir}/${name}":
            content => "${value}\n",
            require => File[$factsdir],
          }
        }
      }
    }
    default: { crit "Invalid ensure value: ${ensure}." }
  }

}
