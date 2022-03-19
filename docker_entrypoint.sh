#!/bin/sh
set -e
_term() { 
  echo "Caught SIGTERM signal!" 
  kill -TERM "$backend_process" 2>/dev/null
}
TOR_ADDRESS=$(yq e '.tor-address' /root/start9/config.yaml)
LAN_ADDRESS=$(yq e '.lan-address' /root/start9/config.yaml)
LND_ADDRESS='lnd.embassy'
HOST_IP=$(ip -4 route list match 0/0 | awk '{print $3}')
echo " \n Starting LNDg... \n"
.venv/bin/pip install whitenoise tzdata && .venv/bin/python initialize.py -net 'mainnet' -server $LND_ADDRESS':10009' -d -dx -dir /mnt/lnd -ip $LAN_ADDRESS
echo "modifying settings.py..."
echo "CORS_ALLOW_CREDENTIALS = True
CORS_ORIGIN_ALLOW_ALL = True
CORS_ALLOW_CREDENTIALS = True
GRPC_DNS_RESOLVER='native'
CSRF_TRUSTED_ORIGINS = ['https://"$LAN_ADDRESS"']
" >> lndg/settings.py
sed -i "s/ALLOWED_HOSTS = \[/&'"$TOR_ADDRESS"',/" lndg/settings.py
sed -i "s/+ '\/data\/chain\/bitcoin\/' + LND_NETWORK +/ + /" /src/lndg/gui/lnd_deps/lnd_connect.py
LNDG_PASS=$(cat data/lndg-admin.txt)
# Properties 
  echo 'version: 2' >> /root/start9/stats.yaml
  echo 'data:' >> /root/start9/stats.yaml
  echo '  Username: ' >> /root/start9/stats.yaml
        echo '    type: string' >> /root/start9/stats.yaml
        echo '    value: lndg-admin' >> /root/start9/stats.yaml
        echo '    description: This is your admin username for LNDg' >> /root/start9/stats.yaml
        echo '    copyable: true' >> /root/start9/stats.yaml
        echo '    masked: false' >> /root/start9/stats.yaml
        echo '    qr: false' >> /root/start9/stats.yaml
  echo '  Password: ' >> /root/start9/stats.yaml
        echo '    type: string' >> /root/start9/stats.yaml
        echo "    value: \"$LNDG_PASS\"" >> /root/start9/stats.yaml
        echo '    description: This is your admin password for LNDg. Please use caution when sharing this password, you could lose your funds!' >> /root/start9/stats.yaml
        echo '    copyable: true' >> /root/start9/stats.yaml
        echo '    masked: true' >> /root/start9/stats.yaml
        echo '    qr: false' >> /root/start9/stats.yaml
echo "running .venv/bin/python manage.py runserver 0.0.0.0:8889 "
.venv/bin/python manage.py runserver 0.0.0.0:8889
&
    backend_process=$!
# ERROR HANDLING
trap _term SIGTERM
wait -n $backend_process 