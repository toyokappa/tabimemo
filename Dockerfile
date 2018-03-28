FROM ruby:2.4.0

ENV APP_ROOT=/usr/src/app
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

RUN apt-get update && \
    apt-get install -y mysql-client \
                       nodejs \
                       cron \
                       vim \
                    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

ADD Gemfile $APP_ROOT
ADD Gemfile.lock $APP_ROOT

RUN bundle install --system # --without development test

ADD . $APP_ROOT

EXPOSE 3000
CMD bin/start_server.sh
