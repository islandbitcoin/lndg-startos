#!/bin/bash
set -e
_term() { 
  echo "Caught SIGTERM signal!" 
  kill -TERM "$backend_process" 2>/dev/null
}

TOR_ADDRESS=$(yq e '.tor-address' /root/start9/config.yaml)
LAN_ADDRESS=$(yq e '.lan-address' /root/start9/config.yaml)
LND_ADDRESS='lnd.embassy'
LNDG_ADDRESS='lndg.embassy'
LNDG_PASS=$(yq e '.password' /root/start9/config.yaml)

# Creating duplicate directory for the lnd macaroon files 
mkdir -p /mnt/lnd/data/chain/bitcoin/mainnet
cp /mnt/lnd/*.macaroon /mnt/lnd/data/chain/bitcoin/mainnet

#Starting LNDg and setting up settings.py
echo
echo "  Starting LNDg... "
echo

# modify the lndg/gui/lnd_deps/lnd_connect.py file to include follwing option grpc.secure_channel
# options=[('grpc.ssl_target_name_override', 'embassy')
if grep -q "grpc.ssl_target_name_override" gui/lnd_deps/lnd_connect.py; then
    echo "SSL override already installed"
else
  sed -i "s/options=\[/options=\[('grpc.ssl_target_name_override', 'embassy'), /" gui/lnd_deps/lnd_connect.py
fi
.venv/bin/pip install --upgrade protobuf
.venv/bin/pip install whitenoise tzdata && .venv/bin/python initialize.py -net 'mainnet' -server $LND_ADDRESS':10009' -d -dx -dir /mnt/lnd -ip $LAN_ADDRESS -p $LNDG_PASS --supervisord
echo "Modifying settings.py..."
echo "CORS_ALLOW_CREDENTIALS = True
CORS_ORIGIN_ALLOW_ALL = True
CORS_ALLOW_CREDENTIALS = True
GRPC_DNS_RESOLVER='native'
CSRF_TRUSTED_ORIGINS = ['https://"$LAN_ADDRESS"']
" >> lndg/settings.py
sed -i "s/ALLOWED_HOSTS = \[/&'"$TOR_ADDRESS"','"$LNDG_ADDRESS"',/" lndg/settings.py
sed -i "s/+ '\/data\/chain\/bitcoin\/' + LND_NETWORK +/ + /" gui/lnd_deps/lnd_connect.py
# change the line below to only run if the django_filters module is not installed
# sed -i "s/INSTALLED_APPS = \[/&'django_filters',/" lndg/settings.py
# check the lndg/settings.py file to see if django_filters is already installed
if grep -q "django_filters" lndg/settings.py; then 
    echo "django_filters already installed"
else
    sed -i "s/INSTALLED_APPS = \[/&'django_filters',/" lndg/settings.py
fi  
# check the lndg/settings.py file to see if filter backends are already installed
if grep -q "DEFAULT_FILTER_BACKENDS" lndg/settings.py; then
    echo "DEFAULT_FILTER_BACKENDS already installed"
else
    sed -i "s/REST_FRAMEWORK = {/&'DEFAULT_FILTER_BACKENDS': ('django_filters.rest_framework.DjangoFilterBackend',),/" lndg/settings.py
fi  
# add the following line to the lndg/settings.py file
# os.environ["GRPC_SSL_CIPHER_SUITES"] = "eNULL"
if grep -q "GRPC_SSL_CIPHER_SUITES" lndg/settings.py; then
    echo "GRPC_SSL_CIPHER_SUITES already installed"
else
    echo 'os.environ["GRPC_SSL_CIPHER_SUITES"] = "eNULL"' >> lndg/settings.py
fi

# Properties Page showing password to be used for login
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

# Starting all processes
echo "Starting jobs.py..."
.venv/bin/python jobs.py
echo "Starting supervisord..."
.venv/bin/supervisord -c /usr/local/etc/supervisord.conf
echo "Starting manage.py..."
.venv/bin/python manage.py runserver 0.0.0.0:8889 & 
echo "Setting up Backend Data, Automated Rebalancing and HTLC Stream Data..."
.venv/bin/python htlc_stream.py &
while true;
do .venv/bin/python jobs.py;
.venv/bin/python rebalancer.py;
sleep 210; 
done 

echo "Shutting down service" &
backend_process=$!
echo "PID: $backend_process"

# SIGTERM HANDLING
trap _term SIGTERM
wait $backend_process
echo "Exit status $?"
