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

Currently it makes use of 3 (!) libraries that lay in `assets/javascripts/vendor` (ProgressBar.js, TinyColor.js, TinyGradient.js). Maybe theses dependencies can be reduced.

### Redirect after sign in

Redirect to the last visited resource-related page or root.

### Redirect after sign out

Let's say, I'm on a public page other than root. If I sign out, I stay on that page, and that's good. But if I sign in right after, I get redirected to root. The method `ApplicationController#after_sign_out_path_for` has been overwritten and that might be important here.

### Handle validation errors in comments#create

Right now, it only logs an info message if a comment failed to save. But currently there's no reason for a comment to be invalid, expect it's blank or it length exceeds 99999 characters. Low priority.

* Allow to attach an existing statement as an argument

* OAuth

* account management pages

* Install back-button

* Include the information about up- and downvoted arguments in the score-formula

* Send Email to creator if there's a new argument for his statement

* Allow users to choose a name

* Allow users to upload an avatar

* Allow users to update his settings

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

### Statements

* Belongs to a `User`

* Attribute `body`: limited to 260 characters on database level

* Attribute `score`: Holds a decimal number within (including) 0 and 1 that represents the strength of the `Statement`

* Attribute `top_level`: A boolean remembering whether the statement was created as an argument for another statement (false) or not (true). Defaults to false.
