#!/bin/sh

_term() {
  echo "caught SIGTERM signal!"
  kill -TERM "$lndg_child" 2>/dev/null
}

python initialize.py -net 'mainnet' -server 'localhost:10009' -d
sleep 5

python manage.py migrate

python manage.py collectstatic --no-input

supervisord

python manage.py runserver 0.0.0.0:8889
sleep 5

render_properties() {
    while true; do
      # sleep 5
      # export SERVER_BUNDLE=$( cat var/lib/cwtch/serverbundle || true )
      if [ -z "$SERVER_BUNDLE" ];
      then
        # Properties 
        echo 'version: 2' > /var/lib/cwtch/start9/stats.yaml
        echo 'data:' >> /var/lib/cwtch/start9/stats.yaml
        echo '  LNDg:' >> /var/lib/cwtch/start9/stats.yaml
        echo '    type: string' >> /var/lib/cwtch/start9/stats.yaml
        echo '    value: "'"{Placeholder}"'"' >> /var/lib/cwtch/start9/stats.yaml
        echo '    description: This is the part you need to capture and import into a Cwtch client app so you can use the server for hosting groups' >> /var/lib/cwtch/start9/stats.yaml
        echo '    copyable: true' >> /var/lib/cwtch/start9/stats.yaml
        echo '    masked: false' >> /var/lib/cwtch/start9/stats.yaml
        echo '    qr: true' >> /var/lib/cwtch/start9/stats.yaml
      else
        # Properties 
        echo 'version: 2' > /var/lib/cwtch/start9/stats.yaml
        echo 'data:' >> /var/lib/cwtch/start9/stats.yaml
        echo '  Node Alias:' >> /var/lib/cwtch/start9/stats.yaml
        echo '    type: string' >> /var/lib/cwtch/start9/stats.yaml
        echo '    value: "'"$SERVER_BUNDLE"'"' >> /var/lib/cwtch/start9/stats.yaml
        echo '    description: This is the part you need to capture and import into a Cwtch client app so you can use the server for hosting groups' >> /var/lib/cwtch/start9/stats.yaml
        echo '    copyable: true' >> /var/lib/cwtch/start9/stats.yaml
        echo '    masked: false' >> /var/lib/cwtch/start9/stats.yaml
        echo '    qr: true' >> /var/lib/cwtch/start9/stats.yaml
      fi
    done
}

trap _term SIGTERM

render_properties &
wait -n $lndg_child 