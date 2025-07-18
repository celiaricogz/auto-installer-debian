#!/bin/bash
set -euo pipefail

# shellcheck source=scripts/common.sh
source "$(dirname "$0")/../scripts/common.sh"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

log "Installing NVIDIA drivers..."

apt install -y nvidia-driver firmware-misc-nonfree

if modprobe nvidia; then
    log "NVIDIA module loaded successfully"
else
    log "Failed to load NVIDIA module"
fi


apt install --reinstall -y nvidia-kernel-dkms
cp "$resources_path"/dkms.conf /var/lib/dkms/nvidia-current/470.256.02/source/
export IGNORE_PREEMPT_RT_PRESENCE=1
dpkg-reconfigure nvidia-kernel-dkms
