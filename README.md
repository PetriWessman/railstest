# README

This is a barebones "Hello world" Rails 6 app, which is hooked up to PostgreSQL but does nothing.

For use in various deployment/container environment and setup tests.

## Heroku

Master key needs to be defined for Heroku (needed in production mode).

`heroku config:set RAILS_MASTER_KEY="8d9c866c95ac3283124a724486aee6ee"`

## Docker (development)

Orchestrated by Docker Compose. Mounts app directory into web container, so code changes done outside the container are visible there.
PostgreSQL database data is mounted to `~/docker/railstest/db` so that it persists across container restarts.

Makefile has some helpers for working with the containers.

Startup with

`docker-compose up`

On first-time install run

`docker-compose exec web rake db:create`

after containers are running to create the (blank) databases.


