FROM ghcr.io/cryptosharks131/lndg:v1.8.0

# arm64 or amd64
ARG PLATFORM
ARG ARCH

RUN apt-get update -y \
  && apt-get upgrade -y\
  && apt-get install -y \
  wget curl tini \
  && wget https://github.com/mikefarah/yq/releases/download/v4.6.3/yq_linux_${PLATFORM}.tar.gz -O - |\
  tar xz && mv yq_linux_${PLATFORM} /usr/bin/yq && chmod +x /usr/bin/yq 

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/*.sh

