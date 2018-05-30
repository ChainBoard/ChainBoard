#!/bin/bash

cd ${APP_DIR}
bundle install --path /app/vendor/bundle

dockerize -wait tcp://${RAILS_DATABASE_HOST}:${RAILS_DATABASE_PORT}

bundle exec rails db:create db:migrate
bundle exec rails server -b 0.0.0.0
