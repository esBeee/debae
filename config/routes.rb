Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  root "statements#index"

  # Let devise take care of the routes for the user resource.
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :statements, only: [:index, :show, :new, :create]
  resources :votes, only: [:create, :destroy]
  resources :comments, only: [:create]

  # New route to reflect the dividing of edit-user-registration
  # into edit account and edit profile.
  get '/users/edit/profile', to: 'users/profiles#edit', as: :edit_user_profile

  # Updating a users profile has a separate controller action and, thus,
  # needs a separate route.
  put '/users/profile', to: 'users/profiles#update', as: :user_profile

  # Routes for the static pages controller
  get '/about', to: 'static_pages#about', as: :about
end
