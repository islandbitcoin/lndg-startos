#!/bin/sh
set -e
export HOST_IP=$(ip -4 route list match 0/0 | awk '{print $3}')
echo " \n Starting service... \n"
cd src/lndg
echo " \n modifying docker-compose to find LND directory... \n"
sed 's/\/root\/<user>\/.lnd/\/mnt\/lnd/' docker-compose.yaml | sed 's/\/root\/<user>\/<path-to>/\/src/'
sed -i 's/\/root\/<user>\/.lnd/\/mnt\/lnd/' docker-compose.yaml | sed 's/\/root\/<user>\/<path-to>/\/src/'
echo " \n Starting LNDg... \n"
# running this will start the LNDg docker and expose the tool at port 8889
#python initialize.py -net 'mainnet' -server '127.0.0.1:10009' -d && supervisord && python manage.py runserver 0.0.0.0:8889
# docker-compose up -d
cd ../..
pwd
echo "listing root"
ls root
echo "listing mnt"
ls mnt
echo "listing find .lnd"
find / -name .lnd
find / -name lnd
/bin/sh