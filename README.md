# Ruby on Rails weather app code challenge for Apple

## Prerequisites and config
This Ruby on Rails weather app was written with Ruby 3.2.2 and Rails 7.0.8.  It requires an API key from OpenWeather, which is put into a .env file in the application root.  See .env.template for details.

## Initial setup
Before running the app for the first time, run `bundle install` from the application root to install all the required gems. Then create the database by running `bin/rails db:setup` from the app root.

## Running
Run the app like many Rails apps, run `bin/rails server` from the app root. This will start the server on localhost with the default port of 3000.  Visit your server by going to [http://localhost:3000](http://localhost:3000)

## Testing
Unit tests can be run from the app root by running `bin/bundle exec rspec`
