# It is not mentioned in the documentation here http://guides.rubyonrails.org/i18n.html,
# but if the available locales aren't set explicitly here, :de will not be accepted.
I18n.config.available_locales = [:en, :de]

# Set the default locale to german globally.
I18n.default_locale = :de
