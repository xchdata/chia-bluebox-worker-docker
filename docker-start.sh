#!/usr/bin/env bash

echo "#"
echo "# Starting timelord launcher."
echo "#"
chia start timelord-launcher-only

trap "echo Shutting down ...; chia stop all -d; exit 0" SIGINT SIGTERM

while sleep 1; do :; done
