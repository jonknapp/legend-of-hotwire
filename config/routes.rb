Rails.application.routes.draw do
  root to: 'homes#show'

  resource :home, only: [:show]
  resources :games do
    resource :guess, only: [:create], module: 'games'
  end
end
