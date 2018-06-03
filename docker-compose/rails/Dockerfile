FROM ruby:2.5.1

ARG GEMFILE
ARG GEMFILE_LOCK

ENV DOCKERIZE_VERSION="v0.6.1" \
    RAILS_DATABASE_HOST="" \
    RAILS_DATABASE_PASSWORD="" \
    RAILS_DATABASE_PORT="" \
    RAILS_DATABASE_USERNAME="" \
    RAILS_ROOT="/var/www/app/"

COPY ["$GEMFILE", \
    "$GEMFILE_LOCK", "$RAILS_ROOT"]

WORKDIR $RAILS_ROOT

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && gem install bundler \
    && bundle install \
    && echo '#!/bin/bash\n\
dockerize -wait tcp://$RAILS_DATABASE_HOST:$RAILS_DATABASE_PORT\n\
bundle exec rails db:create db:migrate db:seed\n\
bundle exec "$@"' >> /docker-entrypoint.sh \
    && chmod 755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["rails", "server", "--binding=0.0.0.0"]
