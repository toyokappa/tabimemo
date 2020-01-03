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

build_rails_image
