FROM ixian-base:18.04

LABEL version="0.1"
LABEL description="Ixian S2 Docker Container"
LABEL maintainer="support@ixian.io"

ENV HOME /opt
ENV NODE_ENV production

ARG URL="https://github.com/ProjectIxian"
ARG BRANCH="master"
ARG SHA=
ARG BOOTSTRAP_URL=
ARG GENESIS_FILE=
ARG WALLET_FILE="/opt/Ixian/Ixian-S2/IxianS2/bin/Release/ixian.wal"
ARG WALLET_PASSWORD="WALLETPASSWORD123"

COPY . /opt
WORKDIR /opt
RUN sh /opt/install.sh "${URL}" "${BRANCH}" "${SHA}" "${BOOTSTRAP_URL}" "${GENESIS_FILE}" "${WALLET_FILE}" "${WALLET_PASSWORD}"

ENTRYPOINT /opt/start.sh