require 'spec_helper_acceptance'

describe 'graphdb::ee::master::repository', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  graphdb_version = ENV['GRAPHDB_VERSION']

  context 'ee installation with master repository' do
    let(:manifest) do
      <<-EOS
			 class{ 'graphdb':
			 version   => '#{graphdb_version}',
			 edition   => 'ee',
			 }

			 graphdb::instance { 'test':
  		 		license        => '/tmp/ee.license',
  				jolokia_secret => 'duper',
  				http_port      => 8080,
			 }

		     graphdb::ee::master::repository { 'test-repo':
		        repository_id       => 'test-repo',
		    	endpoint            => "http://${::ipaddress}:8080",
		    	repository_context  => 'http://ontotext.com/pub/',
		  	 }
		  EOS
    end

    it do
      apply_manifest(manifest, catch_failures: true)
      expect(apply_manifest(manifest, catch_failures: true).exit_code).to be_zero
    end

    describe command("curl -s -X GET 'http://#{fact('ipaddress')}:8080/repositories/test-repo/size'") do
      its(:stdout) { should match /No workers configured/ }
    end
  end
end
