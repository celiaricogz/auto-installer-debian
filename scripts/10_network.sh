#!/bin/bash
set -euo pipefail

# shellcheck source=scripts/common.sh
source "$(dirname "$0")/../scripts/common.sh"

log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

log "Configuring network interfaces"

# shellcheck disable=SC2154
mv /etc/network/interfaces "$backup_path"/interfaces

# shellcheck disable=SC2154
cp "$resources_path"/interfaces /etc/network/interfaces

chmod 777 /etc/network/interfaces

# Restart networking service
/etc/init.d/networking stop
/etc/init.d/networking start

/sbin/ifconfig
