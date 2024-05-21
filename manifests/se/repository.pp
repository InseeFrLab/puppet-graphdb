# @summary This define is able to manage GraphDB repository
#
# @param ensure
#   Whether the service should exist. Possible values are present and absent.
#
# @param endpoint
#   GraphDB endpoint.
#   example: http://localhost:8080
#
# @param repository_context
#   The context of the repository.
#   example: http://ontotext.com
#
# @param repository_template
#   The template to use for repository creation
#   example: http://ontotext.com
#
# @param timeout
#   The max number of seconds that the repository create/delete/check process should wait before giving up.
#   default: 60
#
# For other properties, please, check: {GraphDB documentation}[http://graphdb.ontotext.com/documentation/standard/configuring-a-repository.html?highlight=repository#configuration-parameters]
# 
# @param repository_id
#   Repository ID
#
# @param repository_label
#   Repository title
#
# @param default_ns
#   Default namespaces for imports(';' delimited)
#
# @param entity_index_size
#   Entity index size
#
# @param entity_id_size
#   Entity ID bit-size
#
# @param imports
#   Imported RDF files(';' delimited)
#
# @param ruleset
#   Rule-set
#
# @param storage_folder
#   Storage folder
#
# @param enable_context_index
#   Use context index
#
# @param enable_predicate_list
#   Use predicate indices
#
# @param in_memory_literal_properties
#   Cache literal language tags
#
# @param enable_literal_index
#   Enable literal index
#
# @param check_for_inconsistencies
#   Check for inconsistencies
#
# @param disable_same_as
#   Disable OWL sameAs optimisation
#
# @param transaction_mode
#   Transaction mode
#
# @param transaction_isolation
#   Transaction isolation
#
# @param query_timeout
#   Query time-out (seconds)
#
# @param query_limit_results
#   Limit query results
#
# @param throw_query_evaluation_exception_on_timeout
#   Throw exception on query time-out
#
# @param read_only
#   Read-only
#
define graphdb::se::repository (
  String $endpoint,
  String $repository_context,
  String $ensure              = $graphdb::ensure,
  String $repository_template = "${module_name}/repository/se.ttl.erb",
  Integer $timeout            = 60,

  # Here start the repository parameters(note that those are generated from the template that graphdb provides)
  String $repository_id = $title,
  String $repository_label = 'GraphdDB SE repository',
  String $default_ns = '', # lint:ignore:params_empty_string_assignment
  String $entity_index_size = '200000',
  String $entity_id_size = '32',
  String $imports = '', # lint:ignore:params_empty_string_assignment
  String $ruleset = 'owl-horst-optimized',
  String $storage_folder = 'storage',
  Boolean $enable_context_index = false,
  Boolean $enable_predicate_list = false,
  Boolean $in_memory_literal_properties = false,
  Boolean $enable_literal_index = true,
  Boolean $check_for_inconsistencies = false,
  Boolean $disable_same_as = false,
  String $transaction_mode = 'safe',
  Boolean $transaction_isolation = true,
  String $query_timeout = '0',
  String $query_limit_results = '0',
  Boolean $throw_query_evaluation_exception_on_timeout = false,
  Boolean $read_only = false,
) {
  graphdb_repository { $title:
    ensure              => $ensure,
    repository_id       => $repository_id,
    endpoint            => $endpoint,
    repository_template => template($repository_template),
    repository_context  => $repository_context,
    timeout             => $timeout,
  }
}
