class User::OAuthHandler
  # Gets called with the callback data from a OAuth sign in/up.
  # The method tries to match the user with an existing one or
  # creates a new one if none is found.
  # => Always returns a persistent user object. But might be unconfirmed in some cases.
  def self.from_omniauth auth
    Kazus.log "User.from_omniauth got called!", auth_hash: auth

    provider = auth[:provider]
    uid = auth[:uid]

    # According to the docs at https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema,
    # provider and uid is always present. Inform if it is not and return an unsaved
    # user.
    if provider.blank? || uid.blank?
      Kazus.log :fatal, "Insufficient data from OAuth rqeuest", auth_hash: auth
      return User.new
    end

    info = auth[:info]

    # According to the docs at https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema,
    # info is always present. Inform if it is not and prevent the method from
    # throwing an exception.
    if info.nil?
      Kazus.log :warn, "The info hash on an incoming OAuth request is not present", auth_hash: auth
      info = {} # Make sure that no error gets thrown.
    end

    email = info[:email] # might be nil

    # First, try to find a potentially exisiting user by provider-uid-pair.
    user = User.find_by(provider: provider, uid: uid)

    # If no user was found, try to use the email address to match the user
    # to an existing account, if an email address exists.
    # Note: It's important that email is NOT NIL for this approach.
    if user.nil? && !email.blank? && (user=User.find_by(email: email))
      # If the user was matched by email, make sure provider and uid get saved
      # for this user and fill up other information.
      user_attributes = {}
      user_attributes[:provider] = provider if user.provider.blank?
      user_attributes[:uid] = uid if user.uid.blank?
      if (urls=info[:urls])
        user_attributes[:link_to_facebook] = urls[:Facebook] if urls[:Facebook] && user.link_to_facebook.blank?
        user_attributes[:link_to_twitter] = urls[:Twitter] if urls[:Twitter] && user.link_to_twitter.blank?
        user_attributes[:link_to_google_plus] = urls["Google+"] if urls["Google+"] && user.link_to_twitter.blank?
      end
      
      unless user.update(user_attributes)
        Kazus.log :warn, "[2k4l5mlqf] User invalid", user: user, auth_hash: auth
        user.save(validate: false)
      end
    end

    # If still no user was found, create a new one. We're skipping validation
    # for this if necessary, since email is required normally. Also we're confirming
    # the user in any case to not disrupt the OAuth user experience (and also
    # because it's not sure we have got an email anyway).
    if user.nil?
      # Collect all available user information.
      user_attributes = { provider: provider, uid: uid, password: Devise.friendly_token[8,20], confirmed_at: Time.now }
      user_attributes[:email] = email if email
      user_attributes[:name] = info[:name] if info[:name]
      if (urls=info[:urls])
        user_attributes[:link_to_facebook] = urls[:Facebook] if urls[:Facebook]
        user_attributes[:link_to_twitter] = urls[:Twitter] if urls[:Twitter]
        user_attributes[:link_to_google_plus] = urls["Google+"] if urls["Google+"]
      end

      # Build the new user.
      user = User.new(user_attributes)

      # If a url to an avatar is given, use it.
      user.avatar = avatar_from_url(info[:image]) unless info[:image].blank?

      # Save the user.
      unless user.save
        Kazus.log :warn, "User instance created with OAuth data is invalid", user: user
        user.save(validate: false) # Force saving.
      end
    end

    user
  end

  # Takes a URL to an avatar image and returns a the image in a format
  # paperclip can use to upload the image regularly.
  def self.avatar_from_url url
    URI.parse(url)
  end
end
