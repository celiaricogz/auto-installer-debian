#!/bin/bash
set -euo pipefail

# shellcheck source=scripts/common.sh
source "$(dirname "$0")/../scripts/common.sh"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

PACKAGES_FILE=""$config_path"/pkgs-list.txt"
log "Installing packages from list: $PACKAGES_FILE"

mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$PACKAGES_FILE")

installed=()
failed=()

for package in "${packages[@]}"; do
    log "Installing $package..."
    if apt install -y "$package"; then
        installed+=("$package")
        log "$package installed successfully"
    else
        failed+=("$package")
        log "Error installing $package"
    fi
done

log "Installation summary:"
log "Installed: ${installed[*]:-none}"
log "Failed: ${failed[*]:-none}"

