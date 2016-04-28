Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  root "statements#index"

  # Let devise take care of the routes for the user resource.
  devise_for :users, controllers: { registrations: 'user_registrations' }

  resources :statements, only: [:index, :show, :new, :create]
  resources :votes, only: [:create, :destroy]
  resources :comments, only: [:create]
end
