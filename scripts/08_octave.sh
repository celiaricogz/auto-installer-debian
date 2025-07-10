#!/bin/bash
set -euo pipefail

# shellcheck source=../scripts/common.sh
source "$(dirname "$0")/../scripts/common.sh"

log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

log "Installing Octave and related packages"

apt install -y octave liboctave-dev

octave --eval "
pkg install "$resources_path"/octave_packages/control-3.2.0.tar.gz;
pkg install "$resources_path"/octave_packages/io-2.4.13.tar.gz;
pkg install "$resources_path"/octave_packages/signal-1.4.1.tar.gz;
pkg install "$resources_path"/octave_packages/struct-1.0.16.tar.gz;
pkg install "$resources_path"/octave_packages/optim-1.6.0.tar.gz;
pkg list
"
