FROM python:3
ENV PYTHONUNBUFFERED 1
RUN git clone https://github.com/cryptosharks131/lndg.git /lndg
WORKDIR /lndg
RUN pip install -r requirements.txt
RUN pip install supervisor whitenoise
EXPOSE 8889
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /app/docker_entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]