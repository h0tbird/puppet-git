#------------------------------------------------------------------------------
# Define: git::repo
#
#   This define is part of the git module.
#
#   Marc Villacorta <marc.villacorta@gmail.com>
#   2011-11-26
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
define git::repo (

    $server, $user, $path,
    $ensure = present,
    $owner  = 'root',
    $group  = 'root',
    $mode   = '0664'

) {

    # Validate parameters:
    validate_re($ensure, '^present$|^absent$')

    # Include delegated git class:
    include git

    # Collect variables:
    $templates = getvar("${module_name}::params::templates")

    gitrepo { $name:
        ensure  => $ensure,
        owner   => $owner,
        group   => $group,
        mode    => $mode,
        source  => "git://${server}/${user}/${name}.git",
        path    => $path,
    }

    concat { "${path}/.git/config":
        ensure  => $ensure,
        owner   => $owner,
        group   => $group,
        mode    => $mode,
        require => Gitrepo[$name],
    }

    concat::fragment { "git_${name}_header":
        ensure  => $ensure,
        target  => "${path}/.git/config",
        content => template("${templates}/config_repo_header.erb"),
        order   => '00',
    }
}
