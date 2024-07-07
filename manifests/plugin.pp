# @summary This define allows you to install GraphDB plugin from given source
#
# @param ensure
#   String. Controls if the managed resources shall be <tt>present</tt> or
#   <tt>absent</tt>. If set to <tt>absent</tt>:
#   * The managed plugin is being uninstalled.
#   * Any traces of installation will be purged as good as possible. This may
#     include existing configuration files. The exact behavior is provider
#     dependent. Q.v.:
#     * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
#     * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   * System modifications (if any) will be reverted as good as possible
#     (e.g. removal of created users, services, changed log settings, ...).
#   * This is thus destructive and should be used with care.
#   Defaults to <tt>present</tt>.
#
# @param instance
#   GraphDB instance to install plugin on.
#
# @param source
#   The source of GraphDB plugin.
#
define graphdb::plugin (
  String $instance,
  Graphdb::Ensure $ensure = $graphdb::ensure,
  Optional[String]          $source = undef,
) {
  require graphdb

  $instance_plugins_dir = "${graphdb::data_dir}/${instance}/plugins"

  $plugin_file_name = basename($source)

  file { "${instance_plugins_dir}/${plugin_file_name}":
    ensure => $ensure,
    source => $source,
  }
  ~> exec { "unpack-graphdb-plugin-${title}":
    command     => "rm -rf ${instance_plugins_dir}/${title} && \
                    unzip ${instance_plugins_dir}/${plugin_file_name} -d ${instance_plugins_dir} && \
                    chown -R ${graphdb::graphdb_user}:${graphdb::graphdb_group} ${instance_plugins_dir}/${title}",
    refreshonly => true,
    require     => Package['unzip'],
    notify      => Service["graphdb-${instance}"],
  }
}
