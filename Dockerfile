FROM archlinux:latest

RUN --mount=type=cache,sharing=locked,target=/var/cache/pacman \
    pacman -Sy --noconfirm --needed \
        aws-sdk-cpp \
        boost \
        gcc \
        git \
        make \
        moreutils \
        rapidjson

ARG REPO="https://github.com/xchdata/chiavdf"
ARG BRANCH="xchdata-sqs"
RUN git clone -b ${BRANCH} ${REPO} /chiavdf
WORKDIR /chiavdf/src

COPY docker-entrypoint.sh /usr/local/bin/

ENV VDF_CLIENT_PROCESS_COUNT=
ENV VDF_CLIENT_ID=JohnDoe

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["./bluebox-launcher.sh"]
