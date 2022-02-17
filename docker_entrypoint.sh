#!/bin/sh
echo -e "Starting LNDg..."
# Properties 
echo 'version: 2' > /root/lndg/start9/stats.yaml
echo 'data:' >> /root/lndg/start9/stats.yaml
echo '  LNDg:' >> /root/lndg/start9/stats.yaml
echo '    type: string' >> /root/lndg/start9/stats.yaml
echo '    value: "'"{Placeholder}"'"' >> /root/lndg/start9/stats.yaml
echo '    description: This is the part where you describe stuff.' >> /root/lndg/start9/stats.yaml
echo '    copyable: true' >> /root/lndg/start9/stats.yaml
echo '    masked: false' >> /root/lndg/start9/stats.yaml
echo '    qr: false' >> /root/lndg/start9/stats.yaml

#running this will start the LNDg docker and expose the tool at port 8889
lndg/docker-compose up -d