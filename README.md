[![Gem Version](https://badge.fury.io/rb/scrum_lint.svg)](https://badge.fury.io/rb/scrum_lint) [![Build Status](https://travis-ci.org/ChalkSchools/scrum-lint.svg?branch=master)](https://travis-ci.org/ChalkSchools/scrum-lint) [![Dependency Status](https://gemnasium.com/ChalkSchools/scrum-lint.svg)](https://gemnasium.com/ChalkSchools/scrum-lint) [![Code Climate](https://codeclimate.com/github/ChalkSchools/scrum-lint/badges/gpa.svg)](https://codeclimate.com/github/ChalkSchools/scrum-lint)
[![Test Coverage](https://codeclimate.com/github/ChalkSchools/scrum-lint/badges/coverage.svg)](https://codeclimate.com/github/ChalkSchools/scrum-lint/coverage) [![Inline docs](http://inch-ci.org/github/chalkschools/scrum-lint.svg?branch=master)](http://inch-ci.org/github/chalkschools/scrum-lint)

# ScrumLint

ScrumLint is a tool to manage Chalk's development workflow in Trello and
Github. It provides feedback based on actions that need to be taken to keep our
boards in sync with what is actually happening.

## Installation

```sh
gem install scrum_lint
```

## Usage

ScrumLint expects a `.scrum-lint.yml` file in the current working directory
with at a minimum a `trello_developer_public_key` and `trello_member_token`.
You can see how to acquire these tokens in the ["Basic authorization" section
of the `ruby-trello`
gem](https://github.com/jeremytregunna/ruby-trello#basic-authorization). Once
you've set these, you can run the following command for a list of corrections
to be made:

```sh
scrum-lint
```

Running ScrumLint will run a series of checks against your Trello board to
ensure it is up to date, and list out any violations.

## Linters

**Context**

The Context linter checks that each card in task lists has a context link at
the beginning of it's description. This is expected to be a text label in the
format:

```
Context: <link to a Trello card>
```

## Development

After checking out the repo, run `script/setup` to install dependencies. Then,
run `rake spec` to run the tests. You can also run `script/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/[USERNAME]/scrum_lint. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org) code of
conduct.


## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).
