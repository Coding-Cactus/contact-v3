Rails.application.routes.draw do
  root 'signin#index'
  resources :signin, only: :index

  resources :tickets, only: %i[index show new create update] do
    resources :comments, only: %i[index create]
  end
end
