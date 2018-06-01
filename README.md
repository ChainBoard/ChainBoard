# README

# 開発環境の構築
## コンテナのビルド
既存のコンテナが存在する場合は削除し，新しくコンテナをビルドします．

```
docker rmi cojt-board-project-rails:latest 
UID=$(id -u) GID=$(id -g) docker-compose build
```

## コンテナの立ち上げ

```
docker-compose up
```

## コンテナに入る

```
docker exec -it cojt-board-project_rails_1 /bin/bash
```

# 旧情報
This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
