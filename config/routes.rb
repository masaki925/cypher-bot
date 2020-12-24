Rails.application.routes.draw do
  get '/health/marco', to: 'health#marco'
  namespace :api do
    post 'raps/battle', to: 'raps#battle'
    post 'raps/battle_with_pee', to: 'raps#battle_with_pee'
    post 'raps/battle_with_marco', to: 'raps#battle_with_marco'
    post 'raps/battle_with_toba', to: 'raps#battle_with_toba'
    post 'raps/battle_with_dokaben', to: 'raps#battle_with_dokaben'
  end
end
