# Helpers for Docker

.PHONY: all build clean imageclean console websh psql

all: build

# build image(s)
build:
	docker-compose build

# remove stopped Docker containers
clean:
	docker rm `docker ps -q -a`

# remove non-referenced images
imageclean:
	docker image purge -f

# Rails console in web container
console:
	docker-compose exec web bundle exec rails c

# Shell in web container
websh:
	docker-compose exec web /bin/bash

# Postgres client connected to dev database
psql:
	docker-compose exec web /usr/bin/psql-dev.sh
