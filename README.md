# ParamsConverter

Advanced version of `assert_valid_keys` method. This gem allow to check keys which must be present and can be present. Also it symbolize keys. There are no dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'params_converter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install params_converter

## Usage

This is function without side effects and it's not modify existing hash, but returns new one. The signature of `convert!` method the following:

```ruby
ParamsConverter.convert!(hash, required_keys, allowed_keys)
```

There are a few examples:

```ruby
ParamsConverter.convert!({ a: 1, b: 2, 'c' => 3, d: 4 }, [:a, 'b'], ['c', :d])
# { a: 1, b: 2, c: 3, d: 4 }

ParamsConverter.convert!({ a: 1, b: 2 }, [:c], [:b])
# raises ParamsConverter::MissingRequiredError

ParamsConverter.convert!({ a: 1, b: 2 }, [:a], [:d])
# raises ParamsConverter::MissingRequiredError
```

`nil` instead of second or third parameter is valid value. It means that it allows any required/allowed keys:

```ruby
ParamsConverter.convert!({ a: 1, 'b' => 2 }, nil, nil)
# { a: 1, b: 2 }
```

Empty array instead of required keys means that any key is invalid. Empty array instead of allowed keys means that there are no keys should be present except required keys:

```ruby
ParamsConverter.convert!({ a: 1, 'b' => 2, c: 3 }, [:a, :b, :c], [])
# { a: 1, b: 2, c: 3 }

ParamsConverter.convert!({ a: 1, 'b' => 2, c: 3, d: 4 }, [:a, :b, :c], [])
# raises ParamsConverter::NotAllowedError

ParamsConverter.convert!({ a: 1, 'b' => 2, c: 3, d: 4 }, [], nil)
# raises ParamsConverter::NotAllowedError

```

It should support all versions of ruby, but only ruby 2.1+ is guaranteed.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cimon-io/params_converter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EthWalletFormatValidator project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cimon-io/params_converter/blob/master/CODE_OF_CONDUCT.md).
