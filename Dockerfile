FROM ubuntu:20.04

ENV CHIA_ROOT=/root/.chia/mainnet
ENV TZ="UTC"

ENV VDF_SERVER_HOST=
ENV VDF_SERVER_PORT=8000
ENV VDF_CLIENT_PROCESS_COUNT=

RUN set -ex; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update -q && \
    apt-get install -qy --no-install-recommends \
        bash \
        bc \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        git \
        libboost-python-dev \
        libboost-system-dev \
        libgmp-dev \
        lsb-release \
        openssl \
        python-is-python3 \
        python3 \
        python3-dev \
        python3-pip \
        python3.8-distutils \
        python3.8-venv \
        sudo \
        tar \
        tzdata \
        unzip \
        vim \
        wget && \
    rm -rf /var/lib/apt/lists/* && \
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

ARG REPO="https://github.com/xchdata/chia-blockchain"
ARG BRANCH="xchdata-latest"
RUN git clone --recurse-submodules=mozilla-ca -b ${BRANCH} ${REPO} /srv/chia-blockchain
WORKDIR /srv/chia-blockchain

RUN /bin/bash install.sh
ENV PATH=/srv/chia-blockchain/venv/bin:$PATH

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

COPY docker-start.sh /usr/local/bin/
CMD ["docker-start.sh"]
