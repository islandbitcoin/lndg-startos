#!/bin/sh
set -e

_term() { 
  echo "Caught SIGTERM signal!" 
  kill -TERM "$backend_process" 2>/dev/null
}

TOR_ADDRESS=$(yq e '.tor-address' /root/start9/config.yaml)
LAN_ADDRESS=$(yq e '.lan-address' /root/start9/config.yaml)
LND_ADDRESS='lnd.embassy'
LND_IP=$(getent hosts $LND_ADDRESS | awk '{ print $1 }')
LNDG_ADDRESS='lndg.embassy'
LNDG_PASS=$(yq e '.password' /root/start9/config.yaml)

mkdir -p /mnt/lnd/data/chain/bitcoin/mainnet
cp /mnt/lnd/*.macaroon /mnt/lnd/data/chain/bitcoin/mainnet

echo
echo "  Starting LNDg... "
echo

python initialize.py -net 'mainnet' -rpc $LND_IP':10009' -wn -dir /mnt/lnd -ip $LAN_ADDRESS -p $LNDG_PASS

echo "Modifying settings.py..."
echo "CORS_ALLOW_CREDENTIALS = True
CORS_ORIGIN_ALLOW_ALL = True
CORS_ALLOW_CREDENTIALS = True
GRPC_DNS_RESOLVER='native'
CSRF_TRUSTED_ORIGINS = ['https://"$LAN_ADDRESS"']
" >> lndg/settings.py

sed -i "s/ALLOWED_HOSTS = \[/&'"$TOR_ADDRESS"','"$LNDG_ADDRESS"',/" lndg/settings.py
sed -i "s/+ '\/data\/chain\/bitcoin\/' + LND_NETWORK +/ + /" gui/lnd_deps/lnd_connect.py

if ! grep -q "django_filters" lndg/settings.py; then 
    sed -i "s/INSTALLED_APPS = \[/&'django_filters',/" lndg/settings.py
fi  

if ! grep -q "DEFAULT_FILTER_BACKENDS" lndg/settings.py; then
    sed -i "s/REST_FRAMEWORK = {/&'DEFAULT_FILTER_BACKENDS': ('django_filters.rest_framework.DjangoFilterBackend',),/" lndg/settings.py
fi  

echo 'version: 2' > /root/start9/stats.yaml
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

echo "Starting backend..."
python controller.py runserver 0.0.0.0:8889 & 
backend_process=$!
echo "Backend process PID: $backend_process"

trap _term SIGTERM
wait $backend_process
echo "Exit status $?"
