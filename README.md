## README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

## TODO: Job queueing

Right now, no job queueing adapter is installed. Instructing jobs to be performed later leads to

```
ActiveRecord::ConnectionTimeoutError (could not obtain a connection from the pool within 5.000 seconds (waited 5.000 seconds); all pooled connections were in use)
```

after a couple clicks.

### Conventions

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
