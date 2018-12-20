Rails.application.routes.draw do
  namespace :api do
    post 'raps/battle', to: 'raps#battle'
    post 'raps/battle_with_pee', to: 'raps#battle_with_pee'
    post 'raps/battle_with_marco', to: 'raps#battle_with_marco'
  end
end
