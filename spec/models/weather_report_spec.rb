require 'rails_helper'

RSpec.describe WeatherReport, type: :model do
  subject {
    described_class.new(zip: 12345, temp: 72)
  }

  it "has some weather data" do
    expect(subject).to be_valid
  end

  it "does not have weather data" do
    subject.zip = nil
    expect(subject).to_not be_valid
  end
end
