#!/bin/bash

# エラーで処理中断
set -ex

RAILS_ENV=${RAILS_ENV} bundle exec sidekiq
