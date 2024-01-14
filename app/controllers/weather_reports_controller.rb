class WeatherReportsController < ApplicationController
  def index
  end

  def show
    # Find all ActiveRecords matching the zip code just entered
    recentWeatherRecords = WeatherReport.where(zip: params["id"])
    # If we have at least one match and it's at least 30 minutes fresh, just use that
    if recentWeatherRecords.count > 0 && recentWeatherRecords.last.updated_at + 30.minutes > DateTime.now
      @from_cache = true
      @weather_report = recentWeatherRecords.last
    else
      begin
        # Otherwise, run the API call and add a record
        api_data = $weather_client.current_zip(params[:id])
        @weather_report = WeatherReport.new(
          zip: params[:id],
          lat: api_data.coord.lat,
          lon: api_data.coord.lon,
          temp: api_data.main.temp,
          hi_temp: api_data.main.temp_max,
          low_temp: api_data.main.temp_min,
          city: api_data.name
        )
        @from_cache = false
        @weather_report.save!
      rescue
        redirect_to "/", notice: "Invalid entry"
      end
    end
  end
end
