FROM jenkins/jenkins:lts

ENV DOCKER_VERSION 19.03.5
ENV DOCKER_COMPOSE_VERSION 1.25.0

USER root

# docker, docker composeのインストール
RUN curl -fL -o docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" && \
    tar --strip-components=1 -xvzf docker.tgz -C /usr/bin
RUN curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m`" && \
    chmod +x /usr/local/bin/docker-compose

# dockerをsudoコマンドなしで使用可能に
RUN echo "jenkins ALL=(root) NOPASSWD: /usr/bin/docker" >> /etc/sudoers

USER jenkins