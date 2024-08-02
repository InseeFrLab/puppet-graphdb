# @summary This define is able to manage GraphDB repository
#
# For other properties, please, check: {GraphDB documentation}[http://graphdb.ontotext.com/documentation/enterprise/configuring-a-repository.html?highlight=repository#configuration-parameters]
#
#
# @param check_for_inconsistencies
#   Check for inconsistencies
#
# @param default_ns
#   Default namespaces for imports(';' delimited)
#
# @param disable_same_as
#   Disable OWL sameAs optimisation
#
# @param endpoint
#   GraphDB endpoint.
#   example: http://localhost:8080
#
# @param enable_context_index
#   Use context index
#
# @param enable_literal_index
#   Enable literal index
#
# @param enable_predicate_list
#   Use predicate indices
#
# @param ensure
#   Whether the service should exist. Possible values are present and absent.
#
# @param entity_id_size
#   Entity ID bit-size
#
# @param entity_index_size
#   Entity index size
#
# @param in_memory_literal_properties
#   Cache literal language tags
#
# @param imports
#   Imported RDF files(';' delimited)
#
# @param query_limit_results
#   Limit query results
#
# @param query_timeout
#   Query time-out (seconds)
#
# @param non_interpretable_predicates
#   Non-interpretable predicates
#
# @param read_only
#   Read-only
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
# @param ruleset
#   Rule-set
#
# @param storage_folder
#   Storage folder
#
# @param timeout
#   The max number of seconds that the repository create/delete/check process should wait before giving up.
#   default: 60
#
# @param throw_query_evaluation_exception_on_timeout
#   Throw exception on query time-out
#
# @param transaction_isolation
#   Transaction isolation
#
# @param transaction_mode
#   Transaction mode
#
define graphdb::ee::worker::repository (
  Stdlib::HTTPUrl $endpoint,
  String          $repository_context,
  Graphdb::Ensure $ensure              = $graphdb::ensure,
  String          $repository_template = "${module_name}/repository/worker.ttl.epp",
  Integer         $timeout             = 60,

  # Here start the repository parameters(note that those are generated from the template that graphdb provides)
  String  $default_ns                                   = '', # lint:ignore:params_empty_string_assignment
  Boolean $check_for_inconsistencies                    = false,
  Boolean $disable_same_as                              = false,
  Boolean $enable_context_index                         = false,
  Boolean $enable_literal_index                         = true,
  Boolean $enable_predicate_list                        = false,
  String  $entity_id_size                               = '32',
  String  $entity_index_size                            = '200000',
  Boolean $in_memory_literal_properties                 = false,
  String  $imports                                      = '', # lint:ignore:params_empty_string_assignment
  String  $non_interpretable_predicates = 'http://www.w3.org/2000/01/rdf-schema#label;http://www.w3.org/1999/02/22-rdf-syntax-ns#type;http://www.ontotext.com/owlim/ces#gazetteerConfig;http://www.ontotext.com/owlim/ces#metadataConfig',
  String  $query_timeout                                = '0',
  String  $query_limit_results                          = '0',
  Boolean $read_only                                    = false,
  String  $repository_id                                = $title,
  String  $repository_label                             = 'GraphDB EE worker repository',
  String  $ruleset                                      = 'owl-horst-optimized',
  String  $storage_folder                               = 'storage',
  Boolean $throw_query_evaluation_exception_on_timeout  = false,
  Boolean $transaction_isolation                        = true,
  String  $transaction_mode                             = 'safe',
) {
  graphdb_repository { $title:
    ensure              => $ensure,
    repository_id       => $repository_id,
    endpoint            => $endpoint,
    repository_template => epp($repository_template,
      {
        check_for_inconsistencies                   => $check_for_inconsistencies,
        default_ns                                  => $default_ns,
        disable_same_as                             => $disable_same_as,
        enable_context_index                        => $enable_context_index,
        enable_literal_index                        => $enable_literal_index,
        enable_predicate_list                       => $enable_predicate_list,
        entity_id_size                              => $entity_id_size,
        entity_index_size                           => $entity_index_size,
        imports                                     => $imports,
        in_memory_literal_properties                => $in_memory_literal_properties,
        non_interpretable_predicates                => $non_interpretable_predicates,
        query_limit_results                         => $query_limit_results,
        query_timeout                               => $query_timeout,
        read_only                                   => $read_only,
        repository_id                               => $repository_id,
        repository_label                            => $repository_label,
        ruleset                                     => $ruleset,
        storage_folder                              => $storage_folder,
        throw_query_evaluation_exception_on_timeout => $throw_query_evaluation_exception_on_timeout,
        transaction_isolation                       => $transaction_isolation,
        transaction_mode                            => $transaction_mode,
      }
    ),
    repository_context  => $repository_context,
    timeout             => $timeout,
  }
}
