#!/bin/bash
set -euo pipefail

# shellcheck source=../scripts/common.sh
source "$(dirname "$0")/../scripts/common.sh"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

log "Preparing installation environment..."

crontab -r || true

