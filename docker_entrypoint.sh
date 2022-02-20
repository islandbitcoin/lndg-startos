#!/bin/sh
set -e
export HOST_IP=$(ip -4 route list match 0/0 | awk '{print $3}')
echo " \n Starting LNDg... \n"
pwd
ls -al
cd src
ls -al
cd lndg
ls -al
# running this will start the LNDg docker and expose the tool at port 8889
# python initialize.py -net 'mainnet' -server '127.0.0.1:10009' -d && supervisord && python manage.py runserver 0.0.0.0:8889