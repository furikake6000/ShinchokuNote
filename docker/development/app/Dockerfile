# !!こちらに変更を加えたらproductionにも同様の変更を行うこと!!
#
# devイメージとprodイメージの違い
#   ・vimインストールの有無
#   ・プロジェクトファイルをvolumeで共有する(dev)か、あらかじめCOPYする(prod)か
#   ・bundle install / yarn installを毎度行う(dev)か、build時にやってある(prod)か
#   ・ENTRYPOINTでwebpack buildを行う(prod)かどうか(devの場合は手動でwebpack --watchを走らせる推定)

FROM ruby:2.6.5-slim

# apt update & install
RUN apt-get update -qq && \
    apt-get install -y \
        wget \
        curl \
        git \
        build-essential \
        nodejs \
        npm \
        postgresql-client \
        libpq-dev \
        libsodium-dev \
        graphviz \
        imagemagick \
        cron \
        vim
 
WORKDIR /ShinchokuNote

# entrykit
ENV ENTRYKIT_VERSION 0.4.0
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
    tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
    rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
    mv entrykit /bin/entrykit && \
    chmod +x /bin/entrykit && \
    entrykit --symlink

RUN mkdir -p /var/www/run

# install yarn
RUN npm install yarn -g

ENTRYPOINT [ \
    "prehook", "cp -pR static_files/. public", "--", \
    "prehook", "bundle install -j4 --clean --path vendor/bundle", "--", \
    "prehook", "bundle exec rails assets:precompile", "--", \
    "prehook", "bundle exec whenever --update-crontab", "--", \
    "prehook", "service cron start", "--", \
    "prehook", "rm -f tmp/pids/server.pid", "--"]
