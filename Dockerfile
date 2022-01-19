ARG PYTHON_VERSION=3.8

FROM --platform=$BUILDPLATFORM docker.io/python:${PYTHON_VERSION}-slim as prebuilder
RUN apt-get update && apt-get install -y \
        build-essential \
        libffi-dev \
        libssl-dev \
        rustc \
        zlib1g-dev \
        && rm -rf /var/lib/apt/lists/*

RUN mkdir /root/.cargo
ENV CARGO_HOME=/root/.cargo
RUN pip download --no-binary :all: --no-deps cryptography
RUN tar -xf cryptography*.tar.gz --wildcards cryptography*/src/rust/
RUN cd cryptography*/src/rust && cargo fetch
###
### Stage: builder
###
FROM docker.io/python:${PYTHON_VERSION}-slim as builder

ENV PYTHONUNBUFFERED 1

ADD ./lndg/target/aarch64-unknown-linux-musl/release/lndg /usr/local/bin/lndg

# RUN git clone https://github.com/cryptosharks131/lndg.git /lndg

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

WORKDIR /root

RUN pip install -r requirements.txt
RUN pip install supervisor whitenoise

EXPOSE 8889

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]