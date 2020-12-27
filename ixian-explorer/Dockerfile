FROM ixian-base:18.04

LABEL version="0.1"
LABEL description="Ixian Pool with DLT Docker Container"
LABEL maintainer="support@ixian.io"

ENV HOME /opt
ENV NODE_ENV production

ARG URL="https://github.com/ProjectIxian"
ARG BRANCH="main"
ARG SHA=
ARG DLT_URL="http://ixian-dlt:8081"

COPY . /opt
WORKDIR /opt
RUN sh /opt/install.sh "${URL}" "${BRANCH}" "${SHA}" "${POOL_REWARD_ADDRESS}" "${POOL_FEE}" "${POOL_NAME}" "${POOL_URL}" "${DLT_URL}"

ENTRYPOINT /opt/start.sh