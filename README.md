# 進捗ノート(Shinchoku Note/ Progress notebooks)

進捗ノートは、同人製作者のためのツールです。

## Environments

(2019/12/10現在)

```text
Ruby 2.6.5
Rails 5.2.2
postgresql 10.1
```

残りはGemfileやpackage.json参照

## Quickstart

Docker, Docker Composeが使用可能な環境が必要です。

### installation

```shell
git clone https://github.com/furikake6000/ShinchokuNote.git
```

### build

(`ShinchokuNote`ディレクトリにて)

```shell
sudo docker-compose build
```

### run

```shell
sudo docker-compose -f docker-compose.dev.yml up
```

### puma-dev(Optional)

```shell
brew install puma/puma/puma-dev
sudo puma-dev -setup
mkdir "$HOME/.puma-dev"
echo 3000 > "$HOME/.puma-dev/shinchoku"
puma-dev -install -d test
```

[http://shinchoku.test](http://shinchoku.test)でのアクセスが可能になります。

### DB migration

(初回起動時、もしくはDB構造が変更された時)

```shell
sudo docker-compose run app bin/rails db:migration RAILS_ENV=development
sudo docker-compose run app bin/rails db:migration RAILS_ENV=test
```
