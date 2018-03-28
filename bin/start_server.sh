# !/bin/bash
ln -sf /dev/stdout /usr/src/app/log/${RAILS_ENV}.log
RAILS_ENV=${RAILS_ENV} bundle exec rails db:create
RAILS_ENV=${RAILS_ENV} bundle exec rails db:migrate
bundle exec rails s -b 0.0.0.0
