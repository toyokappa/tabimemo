# tabimemo
旅行のプランをシェアするサービス。旅行の想い出をプランとして投稿したり、他のユーザーが登録したプランを検索できます。今度の休みはどこに行こう？と悩んだ時にプランを検索して旅の計画の材料にすることができるサービスです。

こうしたサービスの開発に着手をしており、サービスの内容や思想に共感頂けるエンジニア、デザイナーがいらっしゃれば、是非ご連絡を頂けますと幸いです。

```
開発者： Yuta Toyokawa
連絡先： kppg42@gmail.com
```

# 開発環境構築
言語等については下記のバージョンを使用しています。
```
Ruby:    2.4.9
Rails:   5.1.7
MySQL:   5.7
```

## 事前準備
各種APIのクレデンシャル情報が必要です。Toyokawaに「各種APIのクレデンシャル情報が必要な旨」をご連絡ください。

## 開発環境セットアップ(Docker環境)
Docker環境も用意しています。Dockerでの環境構築を希望の場合は下記でセットアップしてください。
```bash
git clone git@github.com:toyokappa/tabimemo.git
cd tabimemo/

# 初回のみ実行。5〜10分程度かかります。
docker-compose build
docker-compose up
```
環境が起動したら下記のURLにアクセス。（下記のURLでないとTwitterログインが作動しません）

http://tabimemo.lvh.me:3000

### pryを使ったデバッグを行う場合
pryを使ったデバッグを行う場合は下記の方法で立ち上げるようにしてください。
```bash
MANUAL=1 docker-compose up

# docker-composeが立ち上がったらターミナルの別のタブで下記コマンドを実行
docker-compose exec rails rails s -b 0.0.0.0
```

## デプロイについて
`master`ブランチにPushされたタイミングで`CircleCI`にて自動的にデプロイが走る様に設定をしています。

## インフラ構成
インフラについてはAWSを使用しており、具体的な構成については下記の様になっています。また、インフラの構成管理には`terraform`を使用しており、基本的なインフラの設定変更は`/terraform`ディレクトリにて行います。

## 開発環境セットアップ(Local環境)
Dockerでの環境構築が難しい場合は下記の手順でローカル環境に開発環境のセットアップを進めてください。

### 依存ライブラリ
下記のライブラリを使用していますので、事前にインストールするようにしてください。
```
Redis: PV計測及びSidekiqのqueueを一時的に保管するのに使用
```

### セットアップコマンド
下記のコマンドで開発環境のセットアップが可能です。
```bash
git clone git@github.com:toyokappa/bestcode.git
cd tabimemo/

bundle install --path vendor/bundle
bin/rails db:create
bin/rails db:migrate
bin/rails s -b 0.0.0.0
```

別プロセスでSidekiqのサーバーも立ち上げてください。
```bash
bundle exec sidekiq
```
