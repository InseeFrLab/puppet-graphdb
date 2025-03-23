# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', '..'))
require 'puppet/util/graphdb_request_manager'
require 'puppet/exceptions/graphdb_request_fail'

Puppet::Type.type(:graphdb_validator).provide(:graphdb_validator) do
  desc "A provider for the resource type `graphdb_validator`,
		which checks whether GraphDB instance is running"

  def exists?
    uri = resource[:endpoint]
    uri.path = '/protocol'
    Puppet::Util::GraphDBRequestManager.perform_http_request(uri,
                                                             { method: :get },
                                                             { codes: [200] },
                                                             resource[:timeout])
    true
  rescue Puppet::Exceptions::GraphDBRequestFailError
    false
  end
end
