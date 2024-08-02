# @summary Based on parameters passed defines systemd service
#
# @param ensure
#   Whether the service should exist. Possible values are present and absent.
#
# @param status
#   What the state of the service must be. Possible values are enabled, disabled, running and unmanaged.
#
# @param java_opts
#   Array of java options to give to GraphDB java process
#   example: ['-Xmx1g', '-Xms1g']
#
# @param kill_timeout
#   Time before force kill of GraphDB process. Instances with big repositories may
#   time to flush on shutdown.
#   default: 180
#
define graphdb::service (
  Graphdb::Ensure $ensure,
  Graphdb::Status $status,
  Array           $java_opts    = [],
  Integer         $kill_timeout = 180
) {
  #### Service management

  # set params: in operation
  if $ensure == 'present' {
    case $status {
      # make sure service is currently running, start it on boot
      'enabled': {
        $service_ensure = 'running'
        $service_enable = true
      }
      # make sure service is currently stopped, do not start it on boot
      'disabled': {
        $service_ensure = 'stopped'
        $service_enable = false
      }
      # make sure service is currently running, do not start it on boot
      'running': {
        $service_ensure = 'running'
        $service_enable = false
      }
      # do not start service on boot, do not care whether currently running
      # or not
      'unmanaged': {
        $service_ensure = undef
        $service_enable = false
      }
      # unknown status
      # note: don't forget to update the parameter check in init.pp if you
      #       add a new or change an existing status.
      default: {
        fail("\"${status}\" is an unknown service status value")
      }
    }

    $notify_service = $graphdb::restart_on_change ? {
      true  => [Exec["systemd_reload_${title}"], Service["graphdb-${title}"]],
      false => Exec["systemd_reload_${title}"]
    }
    file { "/lib/systemd/system/graphdb-${title}.service":
      ensure  => $ensure,
      content => epp('graphdb/service/systemd.epp',
        {
          group         => $graphdb::graphdb_group,
          install_dir   => $graphdb::install_dir,
          java_location => $graphdb::java_location,
          java_opts     => generate_java_opts_string($java_opts),
          kill_timeout  => $kill_timeout,
          title         => $title,
          user          => $graphdb::graphdb_user,
        }
      ),
      owner   => 'root',
      group   => 'root',
      before  => Service["graphdb-${title}"],
      notify  => $notify_service,
    }
  } else {
    $service_ensure = 'stopped'
    $service_enable = false

    file { "/lib/systemd/system/graphdb-${title}.service":
      ensure    => 'absent',
      subscribe => Service["graphdb-${title}"],
      notify    => Exec["systemd_reload_${title}"],
    }
  }

  exec { "systemd_reload_${title}":
    command     => '/bin/systemctl daemon-reload',
    path        => ['/bin', '/usr/bin', '/usr/local/bin'],
    refreshonly => true,
  }
  -> service { "graphdb-${title}":
    ensure    => $service_ensure,
    enable    => $service_enable,
    name      => "graphdb-${title}.service",
    hasstatus => true,
    provider  => 'systemd',
  }
}
