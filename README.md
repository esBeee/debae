# debae

_debae_ is a Rails 5.1 app that allows users to make, debate and vote for statements. It is deployed to [https://debae.org/](https://debae.org/).

## Dependencies

### Ruby

[Ruby](https://www.ruby-lang.org/en/) version `2.4.1` is used in production.

### PostgreSQL

[PostgreSQL](https://www.postgresql.org/) version `9.4.9` is used as database in production.

### ImageMagick

File upload is handeled by the [Paperclip](https://github.com/thoughtbot/paperclip) gem, which depends on [ImageMagick](http://www.imagemagick.org/script/index.php).

### yarn

To run this app, the node modules specified in `yarn.lock` must be present. You can install them by running

```sh
$ yarn
```

, after making sure you have [yarn](https://yarnpkg.com/lang/en/) installed.

## Conventions

Don't use :scope in translations. Always write the path in the first argument of a translation. For example

```ruby
I18n.t("something.there.and.there")
```

And not

```ruby
I18n.t("there", scope: "something.there.and")
```
