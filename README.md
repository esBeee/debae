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

### Job queueing

Right now, no job queueing adapter is installed. Instructing jobs to be performed later leads to

```
ActiveRecord::ConnectionTimeoutError (could not obtain a connection from the pool within 5.000 seconds (waited 5.000 seconds); all pooled connections were in use)
```

after a couple clicks.

### Refactor 'Score circle'

Currently it makes use of 3 (!) libraries that lay in `assets/javascripts/vendor` (ProgressBar.js, TinyColor.js, TinyGradient.js). Maybe theses dependencies can be reduced.

### Redirect after sign in

Redirect to the last visited resource-related page or root.

### Redirect after sign out

Let's say, I'm on a public page other than root. If I sign out, I stay on that page, and that's good. But if I sign in right after, I get redirected to root. The method `ApplicationController#after_sign_out_path_for` has been overwritten and that might be important here.

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
