# Based on ideas from https://medium.com/@lemuelbarango/ruby-on-rails-smaller-docker-images-bff240931332
# and other sources
#
# This is for playing around in development mode

# stage 1: build gems

FROM ruby:2.7.2-alpine AS build-base

ARG APP_DIR=/app

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
    git build-base python3 yarn nodejs postgresql-dev tzdata && \
    rm -rf /var/cache/apk/* 

WORKDIR $APP_DIR

COPY Gemfile Gemfile.lock package.json yarn.lock ./

RUN gem install bundler && \
    bundle install && \
    yarn install

# stage 2: development environment

FROM ruby:2.7.2-alpine

ARG APP_DIR=/app

ARG USER_ID=1000
ARG GROUP_ID=1000

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# just include the stuff we want at runtime
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
    nodejs postgresql-client tzdata bash && \
    rm -rf /var/cache/apk/* 

WORKDIR $APP_DIR

# copy gems built by first stage
COPY --from=build-base $GEM_HOME $GEM_HOME

# without the volume mount via Docker Compose, we'd need this to copy over the app data
#COPY --from=build-base $APP_DIR $APP_DIR

# don't run as root, build a "rails" user + group and use those
RUN addgroup --gid $GROUP_ID rails && \
    adduser -D -g 'Rails pseudouser' -u $USER_ID -G rails rails && \
    chown -R rails:rails $APP_DIR

# Add a script to be executed every time the container starts, plus other helpers
COPY scripts/*.sh /usr/bin/
RUN chmod +x /usr/bin/*.sh
ENTRYPOINT ["entrypoint.sh"]

USER $USER_ID

EXPOSE 3000

# default command is Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
