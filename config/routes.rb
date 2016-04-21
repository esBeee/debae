Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  root "statements#index"

  # Let devise take care of the routes for the user resource.
  devise_for :users

  resources :statements, only: [:index, :show]
end
