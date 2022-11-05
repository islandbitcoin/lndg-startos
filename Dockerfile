FROM ubuntu:focal

# arm64 or amd64
ARG PLATFORM
ARG ARCH

RUN apt-get update -y \
    && apt-get upgrade -y\
    && apt-get install -y \
    python3-pip iproute2 wget curl tini \
    && pip3 install virtualenv bash \
    && apt install -y systemctl
RUN wget https://github.com/mikefarah/yq/releases/download/v4.6.3/yq_linux_${PLATFORM}.tar.gz -O - |\
  tar xz && mv yq_linux_${PLATFORM} /usr/bin/yq
COPY . /

WORKDIR /lndg/
RUN virtualenv -p python3 .venv
RUN .venv/bin/python -m pip install --upgrade pip
RUN sed -i "s/protobuf/protobuf==v3.20.0/" ./requirements.txt 
RUN .venv/bin/pip install -r requirements.txt
RUN .venv/bin/pip install supervisor

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

# Persist data
VOLUME /lndg/data
