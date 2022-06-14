#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 5000)); then
    exit 60
else
    if curl --silent --fail lndg.embassy:8889 &>/dev/null then
        echo "The LNDg UI is unreachable" >&2
        exit 1
    fi
fi