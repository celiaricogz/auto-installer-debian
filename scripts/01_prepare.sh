#!/bin/bash
set -euo pipefail

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

log "Preparing installation environment..."

mkdir -p "$backup_path" "$flags_path"
crontab -r || true

