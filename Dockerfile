FROM --platform=linux/arm64/v8 python:3-bullseye
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
COPY . src/
WORKDIR /src/lndg/
RUN pip install -r requirements.txt \
    && pip install supervisor whitenoise

# Embassy Setup for docker entrypoint
WORKDIR /
RUN pip install docker-compose
ADD ./assets/compat/docker-compose.yaml /src/lndg/
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
EXPOSE 8889
ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]