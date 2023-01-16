#!/bin/sh

set -e 

compat duplicity restore /mnt/backup/main /root/data
compat duplicity restore /mnt/backup/data /lndg/data
