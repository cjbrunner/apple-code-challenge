require 'dotenv'
require 'json'
Dotenv.load

Rails.application.config.to_prepare do
  case ENV.fetch("RAILS_ENV", "development")
  in "production"
    # I'm making prod metric to make it more clear when I'm in prod vs dev for now
    $weather_client = OpenWeather::Client.new(api_key: ENV["apiKey"], units: 'metric')
  in "development"
    $weather_client = OpenWeather::Client.new(api_key: ENV["apiKey"], units: 'imperial')
  in "test"
    # TODO: Mock data?
    $weather_client = OpenWeather::Client.new(api_key: ENV["apiKey"], units: 'imperial')
  end
end
