#!/bin/bash
set -e
source /build/buildconfig
set -x

## Temporarily disable dpkg fsync to make building faster.
if [[ ! -e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ]]; then
	echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup
fi

export INITRD=no

# Update repos
apt-get update

## Upgrade all packages.
apt-get dist-upgrade -y --no-install-recommends

if [ -d /build/runit ]; then
	chmod +x /build/runit/*
fi

if [ -d /build/bin ]; then
	chmod +x /build/bin/*
fi

chmod +x /build/*.sh