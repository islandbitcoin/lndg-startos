FROM --platform=linux/arm64/v8 python:3

# Docker setup for LNDg
ENV PYTHONUNBUFFERED 1
COPY . /
WORKDIR /lndg
RUN pip install -r requirements.txt
RUN pip install supervisor whitenoise

# Embassy Setup for docker entrypoint
WORKDIR /
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
EXPOSE 8889
ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]