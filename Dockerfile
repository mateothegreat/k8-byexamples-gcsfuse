#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#
FROM node:9.2-alpine

ENV GOPATH /go
# ENV GOOGLE_APPLICATION_CREDENTIALS=/key.json
ENV GCSFUSE_USER=gcsfuse
ENV GCSFUSE_MOUNTPOINT=/mnt/gcs
ENV GCSFUSE_DEBUG=
ENV GCSFUSE_DEBUG_FUSE=
ENV GCSFUSE_DEBUG_GCS=1
ENV GCSFUSE_DEBUG_HTTP=
ENV GCSFUSE_DEBUG_INVARIANTS=
ENV GCSFUSE_DIR_MODE=
ENV GCSFUSE_FILE_MODE=
ENV GCSFUSE_LIMIT_BPS=
ENV GCSFUSE_LIMIT_OPS=
ENV GCSFUSE_CACHE_STAT_TTL=
ENV GCSFUSE_CACHE_TYPE_TTL=

RUN apk \
    --update \
    --no-cache \
    --virtual build-dependencies \
    add \
    go fuse fuse-dev gettext bash


RUN go get -u github.com/googlecloudplatform/gcsfuse && \
    ln -s /go/bin/gcsfuse /usr/local/bin/gcsfuse && \
    rm -rf /go/pkg/ /go/src/ && \
    gcsfuse --help && \
    mkdir /storage-bucket

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]