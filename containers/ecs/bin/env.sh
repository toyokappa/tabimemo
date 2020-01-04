#! /bin/bash

export APP_NAME=tabimemo
export AWS_ACCOUNT_ID=160320342740
export CONTAINER_REGISTRY=${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com

# タスク定義のprefixから最新のタスク定義のarnを返す
# latest_task_definition aw-cms1-dev
# => arn:aws:ecs:ap-northeast-1:360128825233:task-definition/aw-cms1-dev:43
function latest_task_definition () {
  local cluster_name=$1
  aws ecs list-task-definitions --family-prefix $cluster_name --sort DESC --max-items 1 --region ap-northeast-1 | jq -r '.taskDefinitionArns[0]'
}
