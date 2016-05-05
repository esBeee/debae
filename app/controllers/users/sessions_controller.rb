# Overrides devise's session controller for some individualizations.
class Users::SessionsController < Devise::SessionsController
  layout 'authentication', only: [:new, :create]
end
