Rails.application.routes.draw do
  root 'signin#index'
  resources :signin, only: :index

  resources :tickets, only: %i[index show new create update] do
    resources :comments, only: %i[index create]
  end

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
