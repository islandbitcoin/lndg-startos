#!/bin/sh
set -e
export HOST_IP=$(ip -4 route list match 0/0 | awk '{print $3}')
cd src/lndg
echo " \n Starting LNDg... \n"
# # running this will start the LNDg docker and expose the tool at port 8889
docker-compose up -d