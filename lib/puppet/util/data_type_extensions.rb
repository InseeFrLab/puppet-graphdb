# frozen_string_literal: true

module Puppet
  module Util
    # Constant map contaning file extension with their matching format
    class DataTypeExtensions
      @data_type_ext = { '.rdf' => 'rdfxml', '.rdfs' => 'rdfxml', '.owl' => 'rdfxml', '.xml' => 'rdfxml',
                         '.nt' => 'ntriples',
                         '.ttl' => 'turtle',
                         '.n3' => 'n3',
                         '.trix' => 'trix',
                         '.trig' => 'trig',
                         '.brf' => 'binary',
                         '.nq' => 'nquads',
                         '.jsonld' => 'jsonld',
                         '.rj' => 'rdfjson',
                         '.xhtml' => 'rdfa', '.html' => 'rdfa' }.freeze

      def self.[](extension)
        raise ArgumentError, "Unknown file extensions: #{extension}" unless key?(extension)

        @data_type_ext[extension]
      end

      def self.key?(extension)
        @data_type_ext.key?(extension)
      end

      def self.values
        @data_type_ext.values.uniq
      end
    end
  end
end
