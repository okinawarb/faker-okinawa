Faker::Okinawa
==============

Faker::Okinawa generates Okinawa fake data.

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'faker-okinawa'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install faker-okinawa

Usage
-----

```ruby
require 'faker/okinawa'

Faker::Okinawa::Address.city # => "嘉手納村"
Faker::Okinawa::Address.district # => "平安名"
Faker::Okinawa::Address.island # => "慶留間"
Faker::Okinawa::Address.park # => "がじゃんびら公園"

Faker::Okinawa::Awamori.name # => "久米仙"

Faker::Okinawa::Name.last_name # => "仲村渠"
```

Development
-----------

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Contributing
------------

Bug reports and pull requests are welcome on GitHub at https://github.com/okinawarb/faker-okinawa. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


License
-------

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Faker::Okinawa using [Okinawa dictionary](https://osdn.jp/projects/o-dic/).
The Okinawa dictionary is in o-dic directory, everything under o-dic directory is licensed as [the Okinawa dictionary license](o-doc/doc/README.1ST).
