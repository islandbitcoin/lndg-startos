#!/bin/sh
set -e
echo " \n Starting LNDg... \n"
# echo "running .venv/bin/python initialize.py -net 'mainnet' -server 'localhost:10009' -d -dx -pw 'lndg-admin'"
# .venv/bin/python initialize.py -net 'mainnet' -server 'localhost:10009' -d -dx -pw 'lndg-admin' -dir /mnt/lnd
# echo "running .venv/bin/python manage.py migrate"
# .venv/bin/python manage.py migrate
# echo "running .venv/bin/python manage.py collectstatic --no-input"
# .venv/bin/python manage.py collectstatic --no-input
echo "running .venv/bin/pip install whitenoise tzdata && .venv/bin/python initialize.py -net 'mainnet' -server 'localhost:10009' -d -dx -pw 'lndg-admin' -dir /mnt/lnd"
.venv/bin/pip install whitenoise tzdata && .venv/bin/python initialize.py -net 'mainnet' -server 'localhost:10009' -d -dx -pw 'lndg-admin' -dir /mnt/lnd
echo "running .venv/bin/python manage.py runserver 0.0.0.0:8889 "
.venv/bin/python manage.py runserver 0.0.0.0:8889
# echo "running .venv/bin/python jobs.py"
# .venv/bin/python jobs.py