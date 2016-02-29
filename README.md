[![Circle CI](https://circleci.com/gh/Bernie-2016/signin-api.svg?style=shield)](https://circleci.com/gh/Bernie-2016/signin-api)
[![Code Climate](https://codeclimate.com/github/Bernie-2016/signin-api/badges/gpa.svg)](https://codeclimate.com/github/Bernie-2016/signin-api)
[![Test Coverage](https://codeclimate.com/github/Bernie-2016/signin-api/badges/coverage.svg)](https://codeclimate.com/github/Bernie-2016/signin-api/coverage)

# signin-api

signin-api and signin-frontend are a tool used for guests to sign in at Bernie events.

## Development

### Prerequisites

* git
* ruby 2.3.0 ([rvm](https://rvm.io/) recommended)
* [postgres](http://www.postgresql.org/) (`brew install postgres` on OSX)

### Setup

1. Clone the repository (`git clone git@github.com:Bernie-2016/signin-api.git`)
2. Install gem dependencies: `bundle install`
3. Create and migrate the database: `rake db:setup`
4. Run `rails s` and clone/setup the [client app](https://github.com/Bernie-2016/signin-frontend)

### Testing

* `bundle exec rspec` to run tests
* `bundle exec rubocop` for linting

## Contributing

1. Fork it ( https://github.com/Bernie-2016/signin-api/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Credits

This code was adapted from a private internal project. Portions of this code were contributed by the following users:

* [ajwhite](https://github.com/ajwhite)
* [maclover7](https://github.com/maclover7)
* [JoshSmith](https://github.com/JoshSmith)

## License

[AGPL](http://www.gnu.org/licenses/agpl-3.0.en.html)
