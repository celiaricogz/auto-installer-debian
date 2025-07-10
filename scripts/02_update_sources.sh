#!/bin/bash
set -euo pipefail

# shellcheck source=../scripts/common.sh
source "$(dirname "$0")/../scripts/common.sh"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

log "Updating sources.list and running apt update"

mv /etc/apt/sources.list "$backup_path"/sources.list
cp "$resources_path"/sources.list /etc/apt/sources.list
apt update
