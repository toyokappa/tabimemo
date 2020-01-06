#!/bin/bash

# エラーで処理中断
set -ex

bundle exec sidekiq
