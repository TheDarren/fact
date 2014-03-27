# Example
#
#       fact::text { "su_sysadmin0": value => "SunetID" }
#       fact::text { "su_sysadmin1": value => "SunetID2" }
#       fact::text { "su_support": value => "IDG" }
#       fact::text { "su_restricted": value => "true" }
#

define fact::script (
  $ensure  = present,
  $source  = undef,
  $content = undef
) {
  include fact

  $factsdir = $fact::factsdir

  $filepath = "${factsdir}/${name}"

  if(!$source and !$content){
    fail("fact::script['${name}'' requires a source or content")
  }

  validate_string($content, $source)

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
            content => $content,
            source  => $source,
            owner   => $::id,
            group   => $fact::root_group,
            mode    => '0755',
            require => File[$factsdir],
          }
        }
      }
    }
    default: { crit "Invalid ensure value: ${ensure}." }
  }
}
