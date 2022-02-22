#!/bin/sh
set -e
_term() { 
  echo "Caught SIGTERM signal!" 
  kill -TERM "$backend_process" 2>/dev/null
}
echo " \n Starting LNDg... \n"
.venv/bin/pip install whitenoise tzdata && .venv/bin/python initialize.py \
    -net 'mainnet' -server '4rpfsfb6ryxfbbwhrmvlbx37zzts2di4xhy2ekihz5p3hey5csibvyyd.local:10009' -d -dx \
    -pw 'lndg-admin' -dir /mnt/lnd -ip '4rpfsfb6ryxfbbwhrmvlbx37zzts2di4xhy2ekihz5p3hey5csibvyyd.local'
echo "modifying settings.py"
echo "CORS_ALLOW_CREDENTIALS = True
CORS_ORIGIN_ALLOW_ALL = True
CORS_ALLOW_CREDENTIALS = True
CSRF_TRUSTED_ORIGINS = ['https://4rpfsfb6ryxfbbwhrmvlbx37zzts2di4xhy2ekihz5p3hey5csibvyyd.local']
" >> lndg/settings.py
sed -i "s/+ '\/data\/chain\/bitcoin\/' + LND_NETWORK +/ + /" /src/lndg/gui/lnd_deps/lnd_connect.py
echo "running .venv/bin/python manage.py runserver 0.0.0.0:8889 "
.venv/bin/python manage.py runserver 0.0.0.0:8889 
&
    backend_process=$!
# ERROR HANDLING
trap _term SIGTERM
wait -n $backend_process 