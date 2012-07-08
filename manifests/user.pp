#------------------------------------------------------------------------------
# Define: git::user
#
#   This define is part of the git module.
#
#   Marc Villacorta <marc.villacorta@gmail.com>
#   2011-12-03
#
#   Tested platforms:
#       - CentOS 6
#
# Parameters:
#
# Actions:
#
# Sample Usage:
#
#------------------------------------------------------------------------------
define git::user (

    $ensure   = present,
    $home     = extlookup("user/${name}/home"),
    $fullname = extlookup("user/${name}/name"),
    $email    = extlookup("user/${name}/email"),
    $editor   = extlookup("user/${name}/editor"),
    $difftool = extlookup("user/${name}/difftool"),

) {

    # Validate parameters:
    validate_re($ensure, '^present$|^absent$')

    # Include delegated git class:
    include git

    # Collect variables:
    $templates = getvar("${module_name}::params::templates")

    # Set the requirements:
    if defined(User[$name]) {

        User[$name] -> Git::User[$name]

        concat { "${home}/.gitconfig":
            ensure  => $ensure,
            owner   => $name,
            group   => $name,
            mode    => '0644',
        }

        concat::fragment { "git_${name}_header":
            ensure  => $ensure,
            target  => "${home}/.gitconfig",
            content => template("${templates}/config_user_header.erb"),
            order   => '00',
        }
    }
}
