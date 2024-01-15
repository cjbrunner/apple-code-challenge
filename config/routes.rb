Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # root 'weather_reports#index'
  # get '/weather_reports', to: 'weather_reports#index'
  # get '/weather_reports/:id', to: 'weather_reports#show'
  # post '/weather_reports/:id', to: 'weather_reports#show'
  # post '/weather_reports', to: 'weather_reports#show'
  resource :weather_reports

  root "weather_reports#index"

  get 'health', to: 'health#index'

end
