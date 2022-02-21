#!/bin/sh
set -e
echo " \n Starting LNDg... \n"
echo "running .venv/bin/pip install whitenoise tzdata && .venv/bin/python initialize.py -net 'mainnet' -server 'localhost:10009' -d -dx -pw 'lndg-admin' -dir /mnt/lnd -ip 'hx4lftdn6wiyda5cp2atda6p5sdkusdsrkyifbmqgvwozmhpieo5jcid.local'"
.venv/bin/pip install whitenoise tzdata && .venv/bin/python initialize.py -net 'mainnet' -server 'localhost:10009' -d -dx -pw 'lndg-admin' -dir /mnt/lnd -ip 'hx4lftdn6wiyda5cp2atda6p5sdkusdsrkyifbmqgvwozmhpieo5jcid.local'
echo "running .venv/bin/python manage.py runserver 0.0.0.0:8889 "
.venv/bin/python manage.py runserver 0.0.0.0:8889
