Rails.application.routes.draw do
  root 'signin#index'
  resources :signin, only: :index

  resources :tickets, only: [:index, :show, :new, :create, :update] do
    resources :comments, only: [:index, :create]
  end
end
