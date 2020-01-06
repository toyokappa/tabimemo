#! /bin/bash

# エラーで処理中断
set -ex

# build&deploy共通の環境変数取り込み
source ${BASH_SOURCE%/*}/env.sh

export SHA1=$1
export ENV=$2

# bundle install
BUNDLE_CACHE_PATH=~/caches/bundle
bundle install --path=${BUNDLE_CACHE_PATH}

# asset precompile
SECRET_KEY_BASE=$(aws ssm get-parameters --names "/${APP_NAME}/${ENV}/secret_key_base" --output=text --with-decryption --query "Parameters[0].Value") \
ASSET_SYNC=true \
RAILS_ENV=${ENV} \
bundle exec rails assets:precompile --trace

$(aws ecr get-login --region ap-northeast-1)

# Rails作成
build_rails_image() {
  echo start rails container build
  local rails_docker_cache=~/caches/docker/${APP_NAME}-rails_${ENV}.tar
  local rails_image_name=${CONTAINER_REGISTRY}/${APP_NAME}-rails:${ENV}_${SHA1}

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

# nginx作成
build_nginx_image() {
  echo start nginx container build
  local nginx_docker_cache=~/caches/docker/${APP_NAME}-nginx_${ENV}.tar
  local nginx_image_name=${CONTAINER_REGISTRY}/${APP_NAME}-nginx:latest

  if [[ -e ${nginx_docker_cache} ]]; then
    docker load -i ${nginx_docker_cache}
  fi

  docker build --rm=false -t ${nginx_image_name} ./containers/ecs/nginx
  mkdir -p ~/caches/docker
  docker save -o ${nginx_docker_cache} $(docker history ${nginx_image_name} -q | grep -v missing)
  time docker push ${nginx_image_name}
  echo end nginx container build
}
export -f build_nginx_image

build_rails_image
build_nginx_image
