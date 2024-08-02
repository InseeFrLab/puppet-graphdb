# frozen_string_literal: true

# Fact: graphdb_version
#
# Notes:
#   $facts[graphdb_version]
Facter.add(:graphdb_version) do
  confine :os do |os|
    os['family'] != 'windows'
  end
  setcode do
    if File.exist?('/opt/graphdb/dist/bin/graphdb')
      version = Facter::Util::Resolution.exec('/opt/graphdb/dist/bin/graphdb -v')
      version unless version.nil? || version.empty?
    end
  end
  nil
end
