#!/bin/bash
set -euo pipefail

# shellcheck source=scripts/common.sh
source "$(dirname "$0")/../scripts/common.sh"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

log "Configuring user 'user_name' and home permissions"

user_home="/home/user_name"
if id "user_name" &>/dev/null; then
    chown -R user_name:user_name "$user_home"
    log "Permissions adjusted on $user_home"
else
    log "User 'user_name' not found. Skipping permission configuration."
fi
