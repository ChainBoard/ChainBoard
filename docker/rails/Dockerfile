FROM ruby:2.5.1

ARG GEMFILE
ARG GEMFILE_LOCK

ENV DOCKERIZE_HOSTS="" \
    DOCKERIZE_VERSION="v0.6.1" \
    RAILS_ROOT="/var/www/app" \
    RAILS_TASKS="assets:precompile db:create db:migrate db:seed"

COPY ["$GEMFILE", \
    "$GEMFILE_LOCK", "$RAILS_ROOT/"]

WORKDIR $RAILS_ROOT

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && gem install bundler \
    && bundle install \
    && echo '#!/bin/bash\n\
if [ -f tmp/pids/server.pid ]; then rm tmp/pids/server.pid; fi\n\
if [ -f tmp/sockets/puma.sock ]; then rm tmp/sockets/puma.sock; fi\n\
for dockerize_host in $DOCKERIZE_HOSTS; do dockerize -wait tcp://$dockerize_host; done\n\
bundle exec rails $RAILS_TASKS\n\
bundle exec "$@"' >> /usr/local/bin/docker-entrypoint.sh \
    && chmod 755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["rails", "server", "--binding=0.0.0.0"]
