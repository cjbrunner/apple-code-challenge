class CreateWeatherReports < ActiveRecord::Migration[7.0]
  def change
    create_table :weather_reports do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
