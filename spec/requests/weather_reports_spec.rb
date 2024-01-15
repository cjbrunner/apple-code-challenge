require 'rails_helper'

RSpec.describe "WeatherReports", type: :request do
  before do
    allow($weather_client).to receive(:current_zip).and_return("{\"coord\":{\"lon\":-122.6144,\"lat\":45.4021},\"weather\":[{\"icon_uri\":\"http://openweathermap.org/img/wn/04d@2x.png\",\"icon\":\"04d\",\"id\":804,\"main\":\"Clouds\",\"description\":\"overcast clouds\"}],\"base\":\"stations\",\"main\":{\"temp\":21.31,\"feels_like\":12.61,\"temp_min\":18.46,\"temp_max\":25.66,\"pressure\":1023,\"humidity\":82},\"visibility\":10000,\"wind\":{\"speed\":7,\"deg\":15},\"clouds\":{\"all\":100},\"rain\":null,\"snow\":null,\"dt\":\"2024-01-15T00:47:54.000Z\",\"sys\":{\"type\":2,\"id\":2037911,\"country\":\"US\",\"sunrise\":\"2024-01-14T15:47:03.000Z\",\"sunset\":\"2024-01-15T00:51:18.000Z\"},\"id\":0,\"timezone\":-28800,\"name\":\"Portland\",\"cod\":200}")
  end

  describe "POST /index" do
    it "finds weather" do
      # weather_report = WeatherReport.create(zip: 12345)
      post "/weather_reports", params: {
        weather_report: {
          zip: 12345
        }
      }
      expect(response).to be_successful
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:zip]).to eq(12345)
    end

    it "handles lack of zip code" do
      expect { WeatherReport.create! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
