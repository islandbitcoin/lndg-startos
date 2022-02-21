FROM --platform=linux/arm64/v8 ubuntu:focal
RUN apt-get update -y \
    && apt-get upgrade -y\
    && apt-get install -y \
    python3-pip \
    && pip3 install virtualenv
COPY . src/
WORKDIR /src/lndg/
RUN virtualenv -p python3 .venv
RUN .venv/bin/pip install -r requirements.txt
EXPOSE 8889
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]