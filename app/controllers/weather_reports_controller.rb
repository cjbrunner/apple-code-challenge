require 'indirizzo'

class WeatherReportsController < ApplicationController
  skip_before_action :verify_authenticity_token

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
    begin
      # Parse the address entered
      address = Indirizzo::Address.new(params[:id])
    rescue
      redirect_to "/", notice: "Badly formed address"
    end

    # Find all ActiveRecords matching the zip code just entered
    recentWeatherRecords = WeatherReport.where(zip: address.zip)
    # If we have at least one match and it's at least 30 minutes fresh, just use that
    if recentWeatherRecords.count > 0 && recentWeatherRecords.last.updated_at + 30.minutes > DateTime.now
      @from_cache = true
      @weather_report = recentWeatherRecords.last
    else
      begin
        # Otherwise, run the API call and add a record
        weather_data = translate_weather_api($weather_client.current_zip(address.zip))
        # Insert ZIP code (data from weather API doesn't include it)
        weather_data[:zip] = address.zip
        @weather_report = WeatherReport.create(weather_data)
        @from_cache = false
      rescue
        redirect_to "/", notice: "Invalid entry"
      end
    end
  end

  private

  def translate_weather_api from_api
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
