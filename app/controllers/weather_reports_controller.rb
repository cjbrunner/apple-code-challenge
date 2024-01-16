require 'indirizzo'

class WeatherReportsController < ApplicationController
  if ENV['RAILS_ENV'] == "development"
    # Useful for debugging with Postman
    skip_before_action :verify_authenticity_token
  end

  def index
  end

  def create
    @weather_report = WeatherReport.new(weather_report_params)
    if @weather_report.save!
      render json: @weather_report, status: :created
    else
      render json: @weather_report.errors, status: :unprocessable_entity
    end
  end

  def show
    # Parse the address entered using this helpful gem
    begin
      address = Indirizzo::Address.new(params[:id])
    rescue ArgumentError => error
      # Like, if the user just clicks Search without entering anything
      redirect_to "/", notice: error.message
    else
      if (address.zip.length < 1)
        # Were not able to find a ZIP code
        redirect_to "/", notice: "Badly formed address"
      else
        # Find all ActiveRecords matching the zip code just entered
        recentWeatherRecords = WeatherReport.where(zip: address.zip)
        # If we have at least one match and it's at least 30 minutes fresh, just use that
        if recentWeatherRecords.count > 0 && recentWeatherRecords.last.updated_at + 30.minutes > DateTime.now
          @from_cache = true  # For displaying if a cache hit or not
          @weather_report = recentWeatherRecords.last
        else
          begin
            # Otherwise, run the API call and add a record
            weather_data = translate_weather_api($weather_client.current_zip(address.zip))
            # Insert ZIP code (data from weather API doesn't include it)
            weather_data[:zip] = address.zip
            @weather_report = WeatherReport.create(weather_data)
            @from_cache = false  # For displaying if a cache hit or not
          rescue OpenWeather::Errors::Fault => error
            # Common use case: no/invalid API key
            redirect_to "/", notice: error.message
          rescue
            redirect_to "/", notice: "Invalid entry"
          end
        end
      end
    end
  end

  private

  def translate_weather_api from_api
    # We don't need everything from the API.  Let's translate it into something
    # more human-friendly and stripped-down.
    for_model = {
      lat: from_api.coord.lat,
      lon: from_api.coord.lon,
      temp: from_api.main.temp,
      hi_temp: from_api.main.temp_max,
      low_temp: from_api.main.temp_min,
      city: from_api.name
    }
  end

  def weather_report_params
    params.require(:weather_report).permit(:zip, :lat, :lon, :temp, :hi_temp, :low_temp, :city)
  end
end
