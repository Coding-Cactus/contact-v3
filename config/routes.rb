Rails.application.routes.draw do
  root 'signin#index'
  resources :signin, only: :index

  resources :tickets, only: [:index, :show, :create]
end
