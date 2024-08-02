# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## v1.0.0

- Add comments (lib)
- Add RedHat 9, CentOS 9, Ubuntu 22.04, Debian 12 Support
- Replace legacy_facts (+ modify fact in spec)
- Add tests kernel and os (init.pp)
- Replace notation %w(...) by %w[...]
- Use https://github.com/voxpupuli/gha-puppet/blob/v3/.github/workflows/basic.yml (workflows)
- Add fact graphdb_version
- Change templates ERB in EPP
- Change type params endpoint String to Stdlib::HTTPUrl
- Remove function generate_java_opts_string (use join)

## [v0.10.0](https://github.com/phaedriel/puppet-graphdb/releases/tag/v0.10.0)

- Remove templates init.d and upstart
- Add types : Graphdb::Ensure, Graphdb::Status
- Replace all type parameters ensure by Graphdb::Ensure
- Remove manifest systemd.pp 

## [v0.9.0](https://github.com/phaedriel/puppet-graphdb/releases/tag/v0.9.0)

- Keep debian 11 only (metadata.json)
- Replace validate_xxx
- Change type parameter ensure : now Enum['present', 'absent']
- Remove init and upstart files

## [v0.8.2](https://github.com/phaedriel/puppet-graphdb/releases/tag/v0.8.2)

- Drop debian 10 (metadata.json)
- Use Sensitive for graphdb.properties

## [v0.8.1](https://github.com/phaedriel/puppet-graphdb/releases/tag/v0.8.1)

- Rubocop corrections
- Add parameter $validator_test_enabled in instance.pp to disable this test (enabled by default)

## [v0.8.0](https://github.com/phaedriel/puppet-graphdb/releases/tag/v0.8.0)

- Installation graphdb v10 (remove edition in url and directory)
- Add debian 11 (metadata.json)

## [v0.7.3](https://github.com/phaedriel/puppet-graphdb/releases/tag/v0.7.3)

- [Issue 14 - Enable to override the default value of graphdb.workbench.importDirectory](https://github.com/Ontotext-AD/puppet-graphdb/issues/14)

## [v0.7.2](https://github.com/phaedriel/puppet-graphdb/releases/tag/v0.7.2)

- Correction "Unable to load default_facts.yml: wrong number of arguments ..." during bundle exec rake spec
- "Rollback" Gemfile
- Add Dockerfile 

## [v0.7.1](https://github.com/phaedriel/puppet-graphdb/releases/tag/v0.7.1)

- Correction WARN Missing jolokia-access.xml in graphdb.home.conf
`[WARN ] 2022-01-28 14:25:40,918 [main | c.o.f.j.JolokiaAgentServlet] Missing jolokia-access.xml in graphdb.home.conf location /opt/graphdb/instances/instance/conf for servlet, switching to default policy`

https://graphdb.ontotext.com/documentation/free/configuring-graphdb.html#what-s-in-this-document (Jolokia security policy)

## [v0.7.0](https://github.com/phaedriel/puppet-graphdb/releases/tag/v0.7.0)

- pdk convert and adaptation (Gemfile, ...)
- add parameters type + comments
- change data.pp ensure  => 'present' to ensure  => file, (and modify data_spec.rb)
- Add facter graphdb_java_home (used code : https://github.com/puppetlabs/puppetlabs-java/blob/main/lib/facter/java_default_home.rb)
- Remove facts.d JAVA_HOME.sh
- Add jolokia.xml link in instance.pp (version >= 9.10.0)
- Move params.pp in service::params.pp
- ...

## [v0.6.0](https://github.com/phaedriel/puppet-graphdb/releases/tag/v0.6.0) (22 Jan 2022)

__UPGRADE__
- Ruby minimum 2.0.0

__CHANGE__
- Remove graphdb::ee::backup_cron (and his spec)
- Modify command unpack-graphdb-plugin (rm path and add chown)
- Remove useless condition in params.pp 
- Remove oldest versions in metadata.json
- Add debian 10 version in metadata.json
- Many rubocop corrections : frozen_string_literal ... etc
- Remove some file in spec/acceptance/nodesets (add debian 10)
- Modify errors on master_master_link_manager_spec.rb and master_worker_link_manager_spec.rb

## [v0.5.2](https://github.com/Ontotext-AD/puppet-graphdb/releases/tag/0.5.2) (30 Nov 2020)

- [Releases](https://github.com/Ontotext-AD/puppet-graphdb/releases)
- [Full Changelog](https://github.com/Ontotext-AD/puppet-graphdb/commits/master)
