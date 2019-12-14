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

## 本番(orステージング)サーバーを建てる

VPSサーバーで1から建てる方法
ここではConoHa VPSのDockerインストール済みイメージ(Ubuntu 18.04)を用いて説明する。

### サーバーを借りる & Dockerをインストールする

ConoHa VPSならDockerインストール済みのイメージがあり、簡単に建てられる。
rootパスワードとネームタグを適当に決める。
接続許可ポートは「全て許可」。（SSHポートを変更するため）
ここでssh keyを作っておくとあとあと`ssh-keygen`とか`scp`とかする必要がなくラク。

### ユーザーの作成

SSH、もしくはサーバーコンソールで入って操作

```shell
$ adduser furikake  # ユーザーの追加とパスワードの設定
$ gpasswd -a furikake sudo # sudo権限の追加
```

### SSHとFirewallの設定の変更

先程作ったユーザーでSSHログインができるよう、`/root/.ssh/authorized_keys`を`~/.ssh/`にコピー

```shell
$ su furikake
$ cd  # 自分のhomeディレクトリに
$ mkdir .ssh
$ sudo cp /root/.ssh/authorized_keys ~/.ssh/authorized_keys  # 要sudo
$ sudo chown -R furikake:furikake .ssh  # 所有権を変えないとだめ
```

Firewallの設定を行う。

```shell
$ sudo ufw allow 22  # 後ほど切る。現在のSSH接続を切らないために追加。
$ sudo ufw allow XXXX  # SSH接続に使用するポート番号。
$ sudo ufw allow 80  # http通信。
$ sudo ufw allow 443  # https通信。
$ sudo ufw allow 5432  # postgresqlポート。
# デフォルトではufwがオフになっているので忘れずオンにする。
$ sudo ufw enable
# きちんと設定できているか確認。
$ sudo ufw status verbose
```

誤ってSSH接続を切られてしまったらサーバーコンソールから再挑戦。

続いてSSHの設定。

```shell
$ sudo vim /etc/ssh/sshd_config

# 以下の行を変える
Port XXXX  # 先程SSH用に用意したPort
PetmitRootLogin no
# 最初のConoHaの設定でkeyを作っていなければ以下も
PasswordAuthentication no
```

最後に**クライアント側で**ssh_configを編集する。

```text
Host shinchoku.net
    HostName XXX.XXX.XXX.XXX  # IPアドレス
    User furikake
    Port XXXX  # 設定したポート番号
    IdentityFile ~/.ssh/XXXX  # 保存したpemファイルのパス
```

`ssh shinchoku.net`で接続できることを確認。

## gitからcloneしてきてdocker-compose build

```shell
$ cd
$ git clone https://github.com/furikake6000/ShinchokuNote.git
$ cd ShinchokuNote
$ sudo docker-compose -f docker-compose.prod.yml up -d
```
