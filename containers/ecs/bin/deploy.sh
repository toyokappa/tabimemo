#! /bin/bash

# エラーで処理中断
set -ex

# build&deploy共通の環境変数取り込み
source ${BASH_SOURCE%/*}/env.sh

export SHA1=$1
export ENV=$2
export APP_PREFIX=${APP_NAME}-${ENV}

export TOTAL_MEMORY=1024
export RAILS_MEMORY=768
export SIDEKIQ_MEMORY=256
export DESIRED_COUNT_RAILS=1
export DESIRED_COUNT_SIDEKIQ=1
export RAILS_ENV=${ENV}

deploy_rails() {
  echo "########################################### generate rails task definition start"

  ruby ./containers/ecs/scripts/gen_task_definition.rb \
    --env_file ./containers/ecs/config/${ENV}.env \
    --secrets-file ./containers/ecs/config/secrets.yml \
    --task-definition-template ./containers/ecs/task_definitions/rails_template.json | jq '.' > task_definitions_rails.json
  cat task_definitions_rails.json

  echo "########################################### generate rails task definition end"

  echo "########################################### update rails task definition start"

  aws ecs register-task-definition \
    --cli-input-json file://task_definitions_rails.json \
    --region ap-northeast-1

  local least_task_definition=$(least_task_definition ${APP_PREFIX}-rails)

  aws ecs update-service \
    --cluster ${APP_PREFIX}-cluster \
    --service ${APP_PREFIX}-rails \
    --task-definition ${least_task_definition} \
    --desired-count ${DESIRED_COUNT_RAILS}

  echo "########################################### update rails task definition end"
}
export -f deploy_rails

deploy_sidekiq() {
  echo "########################################### generate sidekiq task definition start"

  ruby ./containers/ecs/scripts/gen_task_definition.rb \
    --env_file ./containers/ecs/config/${ENV}.env \
    --secrets-file ./containers/ecs/config/secrets.yml \
    --task-definition-template ./containers/ecs/task_definitions/sidekiq_template.json | jq '.' > task_definitions_sidekiq.json
  cat task_definitions_sidekiq.json

  echo "########################################### generate sidekiq task definition end"

  echo "########################################### update sidekiq task definition start"

  aws ecs register-task-definition \
    --cli-input-json file://task_definitions_sidekiq.json \
    --region ap-northeast-1

  local least_task_definition=$(least_task_definition ${APP_PREFIX}-sidekiq)

  aws ecs update-service \
    --cluster ${APP_PREFIX}-cluster \
    --service ${APP_PREFIX}-sidekiq \
    --task-definition ${least_task_definition} \
    --desired-count ${DESIRED_COUNT_SIDEKIQ}

  echo "########################################### update sidekiq task definition end"
}
export -f deploy_sidekiq

# 並列にビルドを行う
cat << EOS | xargs -P 2 -Icommand bash -c "set -ex; \command"
deploy_rails
deploy_sidekiq
EOS
