FROM --platform=linux/arm64/v8 ubuntu:focal

ENV LND_ADDRESS $LND_HOST

RUN apt-get update -y \
    && apt-get upgrade -y\
    && apt-get install -y \
    python3-pip iproute2 wget nano \
    && pip3 install virtualenv
RUN wget https://github.com/mikefarah/yq/releases/download/v4.12.2/yq_linux_arm.tar.gz -O - |\
    tar xz && mv yq_linux_arm /usr/bin/yq
COPY . src/
WORKDIR /src/lndg/
RUN virtualenv -p python3 .venv
RUN .venv/bin/pip install -r requirements.txt
EXPOSE 8889
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]