# frozen_string_literal: true

require 'spec_helper'

describe 'graphdb::service', type: :define do
  let :default_facts do
    {
      kernel: 'Linux',
      graphdb_java_home: '/opt/jdk8'
    }
  end

  let(:title) { 'test' }

  let :pre_condition do
    "class { 'graphdb': version => '9.10.1', edition => 'ee' }"
  end

  { 'enabled' => ['running', true],
    'disabled' => ['stopped', false],
    'running' => ['running', false],
    'unmanaged' => [nil, false] }
    .each do |status_param, service_status|
    context 'Debian 11' do
      let(:facts) { default_facts.merge({ 'os' => { 'name' => 'Debian', 'release' => { 'major' => '11' } } }) }

      context "with ensure set to: [present] and status set to: [#{status_param}]" do
        let(:params) { { ensure: 'present', status: status_param } }

        it do
          is_expected.to contain_file('/lib/systemd/system/graphdb-test.service')
            .with(ensure: 'present',
                  owner: 'root',
                  group: 'root',
                  before: "Service[graphdb-test]",
                  notify: ['Exec[systemd_reload_test]', 'Service[graphdb-test]'])
        end

        it do
          is_expected.to contain_file('/lib/systemd/system/graphdb-test.service')
            .with(content: /Description="GraphDB - test"/)
        end
        it do
          is_expected.to contain_file('/lib/systemd/system/graphdb-test.service')
            .with(content: /Group=graphdb/)
        end
        it do
          is_expected.to contain_file('/lib/systemd/system/graphdb-test.service')
            .with(content: /User=graphdb/)
        end
        it do
          is_expected.to contain_file('/lib/systemd/system/graphdb-test.service')
            .with(content: /JAVA_HOME=\/opt\/jdk8/)
        end
        it do
          is_expected.to contain_file('/lib/systemd/system/graphdb-test.service')
            .with(content: /ExecStart=\/opt\/graphdb\/dist\/bin\/graphdb -Dgraphdb.home=\/opt\/graphdb\/instances\/test/)
        end

        it { is_expected.to contain_exec('systemd_reload_test').with(command: '/bin/systemctl daemon-reload', refreshonly: true) }

        it do
          is_expected.to contain_service('graphdb-test').with(
            ensure: service_status[0],
            enable: service_status[1],
            name: 'graphdb-test.service',
            provider: 'systemd',
            hasstatus: true
          )
        end
      end

      context "with ensure set to: [absent] and status set to: [#{status_param}]" do
        let(:params) { { ensure: 'absent', status: status_param } }

        it do
          is_expected.to contain_file('/lib/systemd/system/graphdb-test.service').with(ensure: 'absent', subscribe: 'Service[graphdb-test]')
        end

        it do
          is_expected.to contain_service('graphdb-test').with(
            ensure: 'stopped',
            enable: false,
            name: 'graphdb-test.service',
            provider: 'systemd',
            hasstatus: true
          )
        end
        it { is_expected.to contain_exec('systemd_reload_test').with(command: '/bin/systemctl daemon-reload', refreshonly: true) }
      end
    end
  end
end
