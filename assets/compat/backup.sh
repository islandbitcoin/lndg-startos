#!/bin/sh

set -e 

mkdir -p /mnt/backup/main
mkdir -p /mnt/backup/data
compat duplicity create /mnt/backup/main /root/data
compat duplicity create /mnt/backup/data /app/data
