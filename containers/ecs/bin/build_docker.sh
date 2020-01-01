#! /bin/bash

# エラーで処理中断
set -ex

export APP_NAME=bestcode
export AWS_ACCOUNT_ID=195500977316
export NAMESPACE=toyokappa
export CONTAINER_REGISTRY=${AWS_ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com
export SHA1=$1
export ENV=$2

# bundle install
BUNDLE_CACHE_PATH=~/caches/bundle
bundle install --path=${BUNDLE_CACHE_PATH}

$(aws ecr get-login --region ap-northeast-1)

# Rails作成
build_rails_image() {
  echo start rails container build
  local rails_docker_cache=~/caches/docker/${APP_NAME}-rails_${ENV}.tar
  local rails_image_name=${CONTAINER_REGISTRY}/${NAMESPACE}/${APP_NAME}-rails:${ENV}_${SHA1}

  if [[ -e ${rails_docker_cache} ]]; then
    docker load -i ${rails_docker_cache}
  fi

  docker build --rm=false -t ${rails_image_name} -f ./containers/ecs/rails/Dockerfile .
  mkdir -p ~/caches/docker
  docker save -o ${rails_docker_cache} $(docker history ${rails_image_name} -q | grep -v missing)
  time docker push ${rails_image_name}
  echo end rails container build
}
export -f build_rails_image

build_rails_image
