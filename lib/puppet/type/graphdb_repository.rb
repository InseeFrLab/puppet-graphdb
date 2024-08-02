# frozen_string_literal: true

Puppet::Type.newtype(:graphdb_repository) do
  @doc = 'Creates GraphDB repository'

  ensurable do
    desc 'Ensure value.'
    defaultvalues
    defaultto :present
  end

  newparam(:name, namevar: true) do
    desc 'An arbitrary name used as the identity of the resource.'
  end

  newparam(:repository_id) do
    desc 'The id of the created repository'
    defaultto do
      resource.value(:name)
    end
  end

  newparam(:endpoint) do
    desc 'Sesame endpoint of GraphDB instance'
    validate do |value|
      URI(value)
    rescue StandardError
      raise(ArgumentError, "endpoint should be valid url: #{value}")
    end
    munge do |value|
      URI(value)
    end
  end

  newparam(:repository_template) do
    desc 'The template of the created repository'
  end

  newparam(:repository_context) do
    desc 'The context of the created repository'
  end

  newparam(:node_id) do
    desc 'The node id of master instance'
  end

  newparam(:replication_port) do
    desc 'The replication port used for backups'
    validate do |value|
      Integer(value)
    rescue StandardError
      raise(ArgumentError, "replication_port should be valid integer: #{value}")
    end
    munge do |value|
      Integer(value) unless value.nil?
    end
  end

  newparam(:timeout) do
    desc 'The max number of seconds that graphdb create/delete/check process should wait before giving up
    and deciding that the GraphDB is not running; default: 60 seconds.'
    defaultto 60
    validate do |value|
      Integer(value)
    rescue StandardError
      raise(ArgumentError, "timeout should be valid integer: #{value}")
    end
    munge do |value|
      Integer(value)
    end
  end

  # Autorequire the relevant graphdb_validator
  autorequire(:graphdb_validator) do
    validators = catalog.resources.select do |res|
      next unless res.type == :graphdb_validator

      res if res[:endpoint] == self[:endpoint]
    end
    validators.collect do |res|
      res[:name]
    end
  end
end
