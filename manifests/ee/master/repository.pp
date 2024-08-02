# @summary This define is able to manage GraphDB repository
#
# For other properties, please, check: {GraphDB documentation}[http://graphdb.ontotext.com/documentation/enterprise/configuring-a-repository.html?highlight=repository#configuration-parameters]
#
# @param endpoint
#   GraphDB endpoint.
#   example: http://localhost:8080
#
# @param ensure
#   Whether the service should exist. Possible values are present and absent.
#
# @param node_id
#   Node id of master instance
#   default: endpoint, same as the master instance endpoint
#
# @param replication_port
#   Master replication port used for backups
#   default: 0, random port used
#
# @param repository_context
#   The context of the repository.
#   example: http://ontotext.com
#
# @param repository_id
#   Repository ID
#
# @param repository_label
#   Repository title
#
# @param repository_template
#   The template to use for repository creation
#   example: http://ontotext.com
#
# @param timeout
#   The max number of seconds that the repository create/delete/check process should wait before giving up.
#   default: 60
#
define graphdb::ee::master::repository (
  Stdlib::HTTPUrl $endpoint,
  String          $repository_context,
  Graphdb::Ensure $ensure              = $graphdb::ensure,
  String          $node_id             = "${endpoint}/repositories/${repository_id}",
  Integer         $replication_port    = 0,
  String          $repository_template = "${module_name}/repository/master.ttl.epp",
  String          $repository_id       = $title,
  String          $repository_label    = 'GraphDB EE master repository',
  Integer         $timeout             = 60,
) {
  graphdb_repository { $title:
    ensure              => $ensure,
    repository_id       => $repository_id,
    endpoint            => $endpoint,
    repository_template => epp($repository_template,
      {
        repository_id    => $repository_id,
        repository_label => $repository_label,
      }
    ),
    repository_context  => $repository_context,
    replication_port    => $replication_port,
    node_id             => $node_id,
    timeout             => $timeout,
  }
}
