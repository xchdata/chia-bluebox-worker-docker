#!/usr/bin/env bash
if [ -z "${VDF_SERVER_HOST}" ]; then
	echo "Please configure container environment variable VDF_SERVER_HOST" >&2
	exit 64
fi

NUMPROC=$(nproc --all)
VDFPROC=${VDF_CLIENT_PROCESS_COUNT:-$(($NUMPROC / 2))}

. ./activate

echo "#"
echo "# Locally (re)building vdf_client, to optimise for local CPU."
echo "#"
rm venv/lib/python3.8/site-packages/vdf_client
sh install-timelord.sh

echo "#"
echo "# Running base-line VDF benchmark: './vdf_bench square_asm 400000'"
echo "#"
./vdf_bench square_asm 400000

echo
echo "#"
echo "# Configuring timelord worker for ${VDF_SERVER_HOST}:${VDF_SERVER_PORT} with ${VDFPROC} processes."
echo "#"
chia init
chia configure --set-log-level INFO
chia configure --set-bool farmer.logging.log_stdout true
chia configure --set-str self_hostname 127.0.0.1
chia configure --set-bool prefer_ipv6 true
chia configure --set-str timelord_launcher.host ${VDF_SERVER_HOST}
chia configure --set-int timelord_launcher.port ${VDF_SERVER_PORT}
chia configure --set-int timelord_launcher.process_count ${VDFPROC}

exec "$@"
