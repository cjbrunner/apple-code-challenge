class WeatherReport < ApplicationRecord
  validates :zip, presence: true, allow_blank: false
end
