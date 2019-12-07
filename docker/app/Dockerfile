FROM ruby:2.6.5-slim

# apt update & install
RUN apt-get update -qq && \
    apt-get install -y \
        wget \
        curl \
        git \
        build-essential \
        nodejs \
        postgresql-client \
        libpq-dev \
        libsodium-dev \
        graphviz
 
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

ENTRYPOINT [ "prehook", \
    "bundle install -j4 --clean", \
    "--" ]