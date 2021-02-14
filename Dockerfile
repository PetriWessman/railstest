# Based on ideas from https://medium.com/@lemuelbarango/ruby-on-rails-smaller-docker-images-bff240931332
#
# This is for playing around in development mode, production images can be shrinked down some more

FROM ruby:2.6.6-alpine AS build-base

ARG APP_DIR=/app

# store gems in app dir, so second stage can copy them easily
ENV GEM_HOME="$APP_DIR/.bundle"

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
    git build-base python3 yarn nodejs postgresql-dev tzdata && \
    rm -rf /var/cache/apk/* 

WORKDIR $APP_DIR

COPY Gemfile Gemfile.lock package.json yarn.lock ./

RUN mkdir $GEM_HOME && \
    gem install bundler && \
    bundle install && \
    yarn install

COPY . .

# Build stage done, start runtime stage

FROM ruby:2.6.6-alpine

ARG APP_DIR=/app
ARG USER_ID=1000
ARG GROUP_ID=1000

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV GEM_HOME="$APP_DIR/.bundle"

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
    nodejs postgresql-client tzdata bash && \
    rm -rf /var/cache/apk/* 

WORKDIR $APP_DIR

COPY --from=build-base $APP_DIR $APP_DIR

RUN addgroup --gid $GROUP_ID rails && \
    adduser -D -g 'Rails pseudouser' -u $USER_ID -G rails rails && \
    chown -R rails:rails $APP_DIR

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

USER $USER_ID
EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
