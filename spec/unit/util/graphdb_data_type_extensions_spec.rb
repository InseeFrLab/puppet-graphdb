# frozen_string_literal: true

require 'spec_helper'
require 'puppet/util/graphdb_data_type_extensions'

DATA_TYPE_EXT = { '.rdf' => 'rdfxml', '.rdfs' => 'rdfxml', '.owl' => 'rdfxml', '.xml' => 'rdfxml',
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

DATA_TYPE_EXT.keys.each do |extension|
  describe "#['#{extension}']" do
    it do
      expect(Puppet::Util::GraphDBDataTypeExtensions[extension]).to eq(DATA_TYPE_EXT[extension])
    end
  end

  describe "#key('#{extension}')" do
    it do
      expect(Puppet::Util::GraphDBDataTypeExtensions.key?(extension)).to be true
    end
  end
end

describe "#['not known format']" do
  it do
    expect { Puppet::Util::GraphDBDataTypeExtensions['not known format'] }
      .to raise_error(ArgumentError, 'Unknown file extensions: not known format')
  end
end

describe "#key('not known format')" do
  it do
    expect(Puppet::Util::GraphDBDataTypeExtensions.key?('not known format')).to be false
  end
end

describe '#values' do
  it do
    expect(Puppet::Util::GraphDBDataTypeExtensions.values).to eq(DATA_TYPE_EXT.values.uniq)
  end
end
