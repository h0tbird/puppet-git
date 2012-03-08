#------------------------------------------------------------------------------
# Class: git
#
#   This module manages GIT repositories.
#
#   Marc Villacorta <marc.villacorta@gmail.com>
#   2011-11-26
#
#   Tested platforms:
#       - CentOS 6
#
# Parameters:
#
#   version:    [ present | latest ]
#
# Actions:
#
#   Installs, configures and manages GIT repositories.
#
# Sample Usage:
#
#   include git
#
#   or
#
#   class { 'git': }
#
#   or
#
#   class { 'git':
#       version => present,
#   }
#
#------------------------------------------------------------------------------
class git ( $version = present ) {

    # Validate parameters:
    validate_re($version, '^present$|^latest$')

    # Register this module:
    if defined(Class['motd']) { motd::register { $module_name: } }

    # Set the requirements:
    anchor { "${module_name}::begin":   } ->
    class  { "${module_name}::params":  } ->
    class  { "${module_name}::install": } ->
    anchor { "${module_name}::end":     }
}
