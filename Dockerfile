FROM ubuntu:xenial
MAINTAINER Moe Adham <moe@bitaccess.co>

# Cache buster
# ADD http://www.random.org/strings/?num=10&len=8&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new uuid
RUN apt-get -qq update && \
    apt-get -yqq install \
        vim \
        apt-utils \
        build-essential \
        ca-certificates \
        git-core \
        haveged \
        python-dev \
        python-pip \
        curl \
        software-properties-common && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    rm -rf /tmp/* /var/tmp/*

# https://github.com/bcoin-org/bcoin/commit/6fde0fd7d8d6180d59fd6a3534fe38b31b1329b5
# TAG = v1.0.0-beta.12
ENV BCOIN_BRANCH=master \
    BCOIN_REPO=https://github.com/bcoin-org/bcoin.git \
    TAG=v1.0.0-beta.12

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get install -y nodejs

RUN mkdir -p /code/node_modules/bcoin /data \
    && cd /code/node_modules/ \
    && git clone $BCOIN_REPO \
    && cd /code/node_modules/bcoin && echo $TAG \
    && git checkout tags/$TAG -b $TAG \
    && npm install --production \
    && npm uninstall node-gyp
ADD run_bcoin.sh /code/node_modules/
EXPOSE 8333
EXPOSE 8332
ENV BCOIN_PATH=/code/node_modules/bcoin/bin/node \
    NETWORK=main \
    BITCOIN_DIR=/data/bcoin/mainnet
CMD ["/code/node_modules/run_bcoin.sh"]
