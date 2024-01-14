class ExpandWeatherReport < ActiveRecord::Migration[7.0]
  def change
    add_column :weather_reports, :lat, :numeric
    add_column :weather_reports, :lon, :numeric
    add_column :weather_reports, :temp, :numeric
    add_column :weather_reports, :hi_temp, :numeric
    add_column :weather_reports, :low_temp, :numeric
    add_column :weather_reports, :zip, :integer
    add_column :weather_reports, :city, :string
    remove_column :weather_reports, :title, :string
    remove_column :weather_reports, :body, :string
  end
end
