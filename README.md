GraphDB Puppet module (fork)
---------------------

[![Puppet Forge Version](https://img.shields.io/puppetforge/v/phaedriel/graphdb.svg)](https://forge.puppetlabs.com/phaedriel/graphdb)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/phaedriel/graphdb.svg)](https://forge.puppetlabs.com/phaedriel/graphdb)

#### Table of Contents

1. [Module description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with GraphDB](#setup)
  * [The module manages the following](#the-module-manages-the-following)
  * [Requirements](#requirements)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Advanced features - Extra information on advanced usage](#advanced-features)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Support - When you need help with this module](#support)
8. [License](#license)

## Module description

This module sets up [GraphDB](http://graphdb.ontotext.com/) instances with additional resource for
repository creation, data loading, updates, backups, and more.

This module has been tested on GraphDB 10.0.3, 10.5.x

## Setup

### The module manages the following

* GraphDB repository files.
* GraphDB distribution.
* GraphDB configuration file.
* GraphDB service.
* GraphDB plugins.

### Requirements

* The [stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib) Puppet library.


### Beginning with GraphDB

#### Version 10.0.0

Declare the top-level `graphdb` class and set up an instance:

```puppet
# Since 10.0.0, "edition" paramater is useless.
class{ 'graphdb':
  version              => '10.0.0',
}

graphdb::instance { 'graphdb-instance':
   license           => '/home/graphdb/graphdb.license',
}
```

#### Version 9 and before

Declare the top-level `graphdb` class and set up an instance:

```puppet
class{ 'graphdb':
  version              => '9.10.2',
  edition              => 'se',
}

graphdb::instance { 'graphdb-instance':
   license           => '/home/graphdb/graphdb.license',
}
```

## Usage

Most top-level parameters in the `graphdb` class are set to reasonable defaults.
The following are some parameters that may be useful to override:

#### Removal/Decommissioning

```puppet
class { 'graphdb':
  ensure => 'absent'
}
```

#### Install everything but disable service(s) afterwards

```puppet
class { 'graphdb':
  version              => '9.10.2',
  edition              => 'se',
  status               => 'disabled'
}
```

#### Automatically restarting the service (default set to true)

By default, the module will restart GraphDB when the configuration file changed.
This can be overridden globally with the following option:

```puppet
class { 'graphdb':
  version              => '9.10.2',
  edition              => 'se',
  restart_on_change    => false,
}
```

### Instances

This module works with the concept of instances. For service to start you need to specify at least one instance.

#### Quick setup

```puppet
graphdb::instance { 'graphdb-instance': license => '/home/graphdb/graphdb.license' }
```

This will set up its own data directory and set the service name to: graphdb-instance

#### Advanced options

Instance specific options can be given:

```puppet
graphdb::instance { 'graphdb-instance':
  http_port          => 8080, # http port that GraphDB will use
  kill_timeout       => 180, # time before force kill of GraphDB process
  validator_timeout  => 60, # GraphDB repository validator timeout
  logback_config     => undef, # custom GraphDB logback log configuration
  extra_properties   => { }, # extra properties for graphdb.properties file
  external_url       => undef, # graphDB external URL if GraphDB instance is accessed via proxy, e.g. https://ontotext.com/graphdb
  heap_size          => '2g', # GraphDB  java heap size given by -Xmx parameter. Note heap_size parameter will also set xms=xmx
  java_opts          => [], # extra java opts for java process
  protocol           => 'http', # https or http protocol, defaults to http
}
```

## Limitations

This module has been built on and tested against Puppet 7 and higher.

The module has been tested on:

* Debian 11

Because of init.d/systemd/upstart support the module may run on other platforms, but it's not guaranteed.

## Development

Please see the [CONTRIBUTING.md](https://github.com/Ontotext-AD/puppet-graphdb/blob/master/CONTRIBUTING.md) file for instructions regarding development environments and testing.

## License

Please see the [LICENSE](https://github.com/Ontotext-AD/puppet-graphdb/blob/master/LICENSE)
