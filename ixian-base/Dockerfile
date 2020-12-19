FROM ubuntu:18.04 as ixian-base

LABEL version="0.1"
LABEL description="Ixian Base Docker Container"
LABEL maintainer="support@ixian.io"

ENV HOME /opt
ENV NODE_ENV production

COPY . /opt
WORKDIR /opt
RUN sh /opt/install-base.sh
