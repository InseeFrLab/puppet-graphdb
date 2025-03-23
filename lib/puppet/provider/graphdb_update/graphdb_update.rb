# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', '..'))
require 'puppet/util/graphdb_repository_manager'
require 'puppet/exceptions/graphdb_request_fail'

Puppet::Type.type(:graphdb_update).provide(:graphdb_update) do
  desc "A provider for the resource type `graphdb_update`,
		which executes update query on given GraphDB repository"

  def exists?
    Puppet.debug 'Check whether update has been applied'
    repository_manager.ask(resource[:exists_query], resource[:exists_expected_response], 0)
    true
  rescue Puppet::Exceptions::GraphDBRequestFailError
    false
  end

  def create
    repository_manager.update_query(resource[:update_query], resource[:timeout])
  end

  private

  def repository_manager
    @repository_manager ||= Puppet::Util::GraphDBRepositoryManager.new(resource[:endpoint], resource[:repository_id])
  end
end
