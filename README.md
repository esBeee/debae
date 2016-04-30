# debae rails

debae is a rails 5 (beta) app which allows users to debate given statements. It is deployed to [https://debae.herokuapp.com/](https://debae.herokuapp.com/).

Ruby 2.3.0 is being used.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

## Dependencies

### ImageMagick

File upload is handeled by the [Paperclip](https://github.com/thoughtbot/paperclip) gem, which depends on [ImageMagick](http://www.imagemagick.org/script/index.php). If you're on a mac, simply run `brew install imagemagick`.

## TODOs

### Logging on heroku

It appears, that even with `log_level` set to `:warn` in `production.rb` and with the ENV variable `LOG_LEVEL` set to `WARN`, it still logs everything.

### Job queueing

Right now, no job queueing adapter is installed. Instructing jobs to be performed later leads to

```
ActiveRecord::ConnectionTimeoutError (could not obtain a connection from the pool within 5.000 seconds (waited 5.000 seconds); all pooled connections were in use)
```

after a couple clicks.

Both, defined jobs and emails sent by devise should be delayed.

### Refactor 'Score circle'

Currently it makes use of 3 (!) libraries that lay in `assets/javascripts/vendor` (ProgressBar.js, TinyColor.js, TinyGradient.js). Maybe these dependencies can be reduced.

### Redirect after sign in

Redirect to the last visited resource-related page or root.

### Redirect after sign out

Let's say, I'm on a public page other than root. If I sign out, I stay on that page, and that's good. But if I sign in right after, I get redirected to root. The method `ApplicationController#after_sign_out_path_for` has been overwritten and that might be important here.

### Handle validation errors in comments#create

Right now, it only logs an info message if a comment failed to save. But currently there's no reason for a comment to be invalid, expect it's blank or it length exceeds 99999 characters. Low priority.

### OAuth

If a user has signed in with facebook, then signs in with google (but both accounts with the same email address), the google uid is not saved. This might be changed by storing the user's uid and provider in a hash that takes several providers and uids.

### Various

* Store a comment to be created in session in case the user's session turns out to be expired. In this case, after sign in, the comment can be prefilled and be created then.

* Allow to attach an existing statement as an argument

* Reflect the information about up- and downvoted arguments in the score-formula

## Conventions

Don't use :scope in translations. Always write the path in the first argument of a translation. For example

```ruby
I18n.t("something.there.and.there")
```

And not

```ruby
I18n.t("there", scope: "something.there.and")
```

Also always hand default messages to translations:

```ruby
I18n.t("something.there.and.there", default: "There")
```

## Models

### User

* Devise model with corresponding attributes.

* Attribute `email`: The users primary email address. Required, if a user signs up with email, but might be nil, if the user used OAuth.

* Attribute `name`: The users name. May be a full name or a username or whatever, but can't be blank. Limited to 70 characters on database level. Can't be nil (on database level).

* Attribute `avatar`: This is a virtual attribute, dependent on four database columns (`avatar_file_name`, `avatar_content_type`, `avatar_file_size`, `avatar_updated_at`). They are managed by the gem paperclip. Read the [docs](https://github.com/thoughtbot/paperclip) for usage information. It stores 4 sizes of each uploaded image: `:thumb`, `:square`, `:medium` and `:original`. They can be used in views like `image_tag @user.avatar.url(:original)`.

* Attribute `email_if_new_argument`: A boolean that is true if the user wants to receive email notifications each time a new argument was added to one of his statements, or false otherwise. Defaults to true.

* Attributes `link_to_facebook`, `link_to_twitter`, `link_to_google_plus`: A string (limited to 100 characters on database level) containing the link to the user's social network page.

### Statement

* Belongs to a `User`. Might be nil if the user has deleted his account.

* Attribute `body`: Limited to 260 characters on database level. Can't be nil (on database level).

* Attribute `score`: Holds a decimal number within (including) 0 and 1, that represents the strength of the `Statement`.

* Attribute `top_level`: A boolean remembering whether the statement was created as an argument for another statement (false) or not (true). Defaults to false.
