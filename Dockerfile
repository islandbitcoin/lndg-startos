FROM --platform=linux/arm64/v8 python:3-slim-bullseye

# Docker setup for LNDg
ENV PYTHONUNBUFFERED 1
COPY . src/
# WORKDIR /src/lndg
# RUN pip install -r requirements.txt && pip install supervisor whitenoise

# Embassy Setup for docker entrypoint
# WORKDIR /
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
EXPOSE 8889
ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]