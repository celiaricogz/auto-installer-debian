#!/bin/bash
set -euo pipefail

# shellcheck source=../scripts/common.sh
source "$(dirname "$0")/../scripts/common.sh"

log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

log "Installing and configuring NTP"

apt install -y ntp ntpdate

# Backup and apply ntp.conf
mv /etc/ntp.conf "$backup_path"/ntp.conf
cp "$resources_path"/ntp.conf /etc

/etc/init.d/ntp restart

ntpdc -n <<EOF
dmp
exit
EOF
