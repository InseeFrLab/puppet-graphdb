# Contributing

If you have a bugfix or new feature that you would like to contribute to this puppet module, please find or open an issue about it first.
Talk about what you would like to do.

We enjoy working with contributors to get their code accepted.
There are many approaches to fixing a problem and it is important to find the best approach before writing too much code.

## The test matrix

### Syntax and style

The test suite will run [Puppet Lint](http://puppet-lint.com/) and
[Puppet Syntax](https://github.com/gds-operations/puppet-syntax) to
check various syntax and style things. You can run these locally with:

```sh
bundle exec rake lint
bundle exec rake validate
```

It will also run some [Rubocop](http://batsov.com/rubocop/) tests
against it. You can run those locally ahead of time with:

```sh
bundle exec rake rubocop
```

### Running the unit tests

The unit test suite covers most of the code, as mentioned above please
add tests if you're adding new functionality. If you've not used
[rspec-puppet](http://rspec-puppet.com/) before then feel free to ask
about how best to test your new feature.

To run your all the unit tests

```sh
bundle exec rake spec
```

To run a specific spec test set the `SPEC` variable:

```sh
bundle exec rake spec SPEC=spec/foo_spec.rb
```

## Generate REFERENCE.md

Use the pupept command

```sh
puppet strings generate --format markdown --out REFERENCE.md
```
