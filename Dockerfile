FROM ruby:2.4.6

ENV APP_ROOT=/usr/src/app
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

RUN apt-get update && \
    apt-get install -y default-mysql-client \
                       nodejs \
                       cron \
                       vim \
                    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

ADD Gemfile $APP_ROOT
ADD Gemfile.lock $APP_ROOT

RUN gem update --system
RUN bundle install --system # --without development test

ADD . $APP_ROOT

EXPOSE 3000
