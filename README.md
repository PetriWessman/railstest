# README

This is a barebones "Hello world" Rails 6 app, which is hooked up to PostgreSQL but does nothing.

For use in various deployment/container setup tests.

The master key file (config/master.key) has been removed, the master key needed to run this in production is

8d9c866c95ac3283124a724486aee6ee

So to run on Heroku, for example, do something like

heroku config:set RAILS_MASTER_KEY="8d9c866c95ac3283124a724486aee6ee"

