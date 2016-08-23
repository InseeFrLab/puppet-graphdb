$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', '..'))

require 'uri'
require 'puppet/util/data_type_extensions'
require 'puppet/util/file_utils'

Puppet::Type.newtype(:graphdb_data) do
  @doc = 'Loads data into GraphDB'

  ensurable do
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
      raise 'endpoint should be valid url' unless URI(value)
    end
    munge do |value|
      URI(value)
    end
  end

  newparam(:data_format) do
    desc 'The format of the data. e.g.: turtle'
    newvalues(*Puppet::Util::DataTypeExtensions.values)
  end

  newparam(:data) do
    desc "The data you want to load into repository
    Supported formats:
    String: 'data'
    Array: ['data#1','data#2']
    Array of Hashes: [{'content' => 'data#1', 'context' => 'context_of_data#1', 'format' => 'format_of_data1'},
    {'content' => 'data#2', 'context' => 'context_of_data#2', 'format' => 'format_of_data2'}]
    Mixed Array: [{'content' => 'data#1', 'context' => 'context_of_data#1', 'format' => 'format_of_data1'}, 'data#2']
    note#1: if context for data not provided data_context is used
    note#2: if format for data not provided data_format is used"
    validate do |value|
      raise 'you shoud pass data or data_source, not both' unless resource.value(:data_source).nil?

      if value.is_a?(String)
        raise 'you should pass data_format' if resource.value(:data_format).nil?
      elsif value.is_a?(Array)
        value.each do |data|
          if data.is_a?(Hash)
            raise 'you should provide data content through content' unless data.key?(:content)
            if !data.key?(:format) && resource.value(:data_format).nil?
              raise "you should provide data format for #{data[:content]} through format or data_format"
            end
          else
            raise 'you should pass data_format' if resource.value(:data_format).nil?
          end
        end
      else
        raise 'data should be string or array'
      end
    end

    munge do |value|
      if value.is_a?(String)
        return [{ content: value, format: resource.value(:data_format), context: resource.value(:data_context) }]
      elsif value.is_a?(Array)
        resulted_array = []
        value.each do |data|
          if data.is_a?(Hash)
            resulted_hash = { content: data['content'] }
            resulted_hash[:context] = data.key?('context') ? data['context'] : resource.value(:data_context)

            if data.key?('format')
              resulted_hash[:format] = data['format']
            elsif !resource.value(:data_format).nil?
              resulted_hash[:format] = resource.value(:data_format)
            else
              raise "you should provide data format for #{data[:content]} through format or data_format"
            end
            resulted_array << resulted_hash
          else
            resulted_array << [{ content: data, format: resource.value(:data_format), context: resource.value(:data_context) }]
          end
        end
        return resulted_array
      end
    end
  end

  newparam(:data_source) do
    desc "The source of data you want to load into repository
    Supported formats:
    String: 'path_to_file'
    String: 'path_to_directory'
    Array: ['path_to_file#1','path_to_file#2']
    Array of Hashes: [{'source' => 'path_to_file#1', 'context' => 'context_of_file#1', 'format' => 'format_of_file#1'},
    {'source' => 'path_to_file#2', 'context' => 'context_of_file#2', 'format' => 'format_of_file#2'}]
    Mixed Array: [{'source' => 'path_to_file#1', 'context' => 'context_of_file#1', 'format' => 'format_of_file#1'},
    'path_to_file#2']
    note#1: if context for file not provided data_context is used
    note#2: if format for file not provided trying to resolve format from file if fails data_format is used"

    validate do |data_sources|
      raise 'you shoud pass data or data_source, not both' unless resource.value(:data).nil?

      if data_sources.is_a?(String)
        check_absolute_source_path(data_sources)
      elsif data_sources.is_a?(Array)
        data_sources.each do |data_source|
          if data_source.is_a?(Hash)
            raise 'you should provide source through source' unless data_source.key?('source')
            check_absolute_source_path(data_source['source'])
          else
            check_absolute_source_path(data_source)
          end
        end
      else
        raise 'data_source should be string or array'
      end
    end

    def check_absolute_source_path(path)
      raise "#{path} is not absolute path" unless Puppet::Util::FileUtils.is_absolute_path(path)
    end

    munge do |data_source|
      if data_source.is_a?(String)
        return [{ source: data_source, format: resource.value(:data_format), context: resource.value(:data_context) }]
      elsif data_source.is_a?(Array)
        data_array = []
        data_source.each do |source|
          data_hash = {}
          if source.is_a?(Hash)
            data_hash[:source] = source['source']
            data_hash[:context] = source.key?('context') ? source['context'] : resource.value(:data_context)
            data_hash[:format] = source.key?('format') ? source['format'] : resource.value(:data_format)
          else
            data_hash = { source: source, format: resource.value(:data_format), context: resource.value(:data_context) }
          end
          data_array << data_hash
        end
        return data_array
      end
    end
  end

  newparam(:data_context) do
    desc 'The context you want to load your data into; default: null'
    defaultto('null')
    validate do |value|
      raise 'data_context should be not empty string' unless value.is_a?(String) && !value.empty?
    end
    munge(&:strip)
  end

  newparam(:data_overwrite) do
    desc 'Wheather to overwrite any existing data; default: false'
    defaultto(:true)
    newvalues(:true, :false)
  end

  newparam(:exists_query) do
    desc 'The ask query to check whether data is already loaded. You can use the following syntax: ask {?s ?p ?o}'
  end

  newparam(:exists_expected_response) do
    desc 'The expected response from exists_query'
    defaultto(:true)
    newvalues(:true, :false)
  end

  newparam(:timeout) do
    desc 'The max number of seconds that the validator should wait before giving up; default: 60 seconds'
    defaultto 60
    validate do |value|
      raise 'timeout should be valid integer' unless Integer(value)
    end
    munge do |value|
      Integer(value)
    end
  end

  # Autorequire the relevant graphdb_repository
  autorequire(:graphdb_repository) do
    catalog.resources.select do |res|
      next unless res.type == :graphdb_repository
      res if res[:endpoint] == self[:endpoint] && res[:repository_id] == self[:repository_id]
    end.collect do |res|
      res[:name]
    end
  end
end
