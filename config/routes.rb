Rails.application.routes.draw do
  namespace :api do
    post 'raps/battle', to: 'raps#battle'
  end
end
