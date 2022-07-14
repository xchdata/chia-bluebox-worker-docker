#!/usr/bin/env bash
if [ -z "${VDF_CLIENT_ID}" ]; then
	echo "Please configure container environment variable VDF_CLIENT_ID" >&2
	exit 64
fi

export VDF_CLIENT_PROCESS_COUNT=${VDF_CLIENT_PROCESS_COUNT:-$(nproc --all)}

echo "#"
echo "# Building (improved) VDF bluebox worker."
echo "#"
make -f Makefile.vdf-client bluebox_worker vdf_bench

echo
echo "#"
echo "# Running base-line VDF benchmark: \`vdf_bench square_asm 400000\`"
echo "#"
./vdf_bench square_asm 400000

echo
echo "#"
echo "# Obtaining public IP."
echo "#"
curl -s ip6.me/api/

echo
echo "#"
echo "# Starting VDF bluebox worker."
echo "#"

exec "$@"
