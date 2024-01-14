class WeatherReportsController < ApplicationController
  def index
  end

  def show
    # Find all ActiveRecords matching the zip code just entered
    recentWeatherRecords = WeatherReport.where(title: params["id"])
    # If we have at least one match and it's at least 30 minutes fresh, just use that
    if recentWeatherRecords.count > 0 && recentWeatherRecords.last.updated_at + 30.minutes > DateTime.now
      @weather_report = recentWeatherRecords.last.to_json
    else
      begin
        # Otherwise, run the API call and add a record
        @weather_report = $weather_client.current_zip(params[:id]).to_json
        wr = WeatherReport.new(title: params[:id], body: @weather_report)
        wr.save!
      rescue
        redirect_to "/", notice: "Invalid entry"
      end
    end
  end
end
