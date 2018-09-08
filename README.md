# README

Check this url for testing the app https://devcity.herokuapp.com/
Check this url to see api documentation https://devcity.herokuapp.com/docs

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

## Ruby version

**> ruby-2.5.0**

## System dependencies

* Postgresql version 9.5

## Database creation

Please run this code in sequence

```
rake db:create
```

## Database initialization

Please run this code in sequence

```
rake db:migrate
rake db:seed
```

## How to run the test suite
```
rspec spec/api/v1/dev_cities_controller_spec.rb

```