# SonJay

Symmetrical transformation between structured data and JSON

Allows concrete object/array data model classes to be defined,
and then allows JSON serialization/parsing from/to an instance
of one of those classes.

This allows a single body of code to be used to define a JSON
API structure for a provider and its clients.

Instances of these models can also be used to help keep
automated tests simple and reliable. Attempts by test setup
code or code under test to produce incorrectly structured
data will generally fail in a fast, informative way.

## Installation

Add this line to your application's Gemfile:

    gem 'son_jay'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install son_jay

## Usage

- [Serialization](features/json_serialization.feature)
- [Parsing](features/json_parsing.feature)

## Contributing

1. Fork it ( http://github.com/<my-github-username>/son_jay/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
