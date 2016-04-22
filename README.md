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

### Conventions

* Don't use :scope in translations. Always write the path in the first argument of a ttranslation. For example

I18n.t("something.there.and.there")

And not

I18n.t("there", scope: "something.there.and")

Also always give default messages to translations:

I18n.t("something.there.and.there", default: "There")
