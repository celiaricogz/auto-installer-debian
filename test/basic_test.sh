#!/bin/bash
set -euo pipefail

# shellcheck source=scripts/common.sh
source "$(dirname "$0")/../scripts/common.sh"

echo "[TEST] Checking that install.sh is executable..."
[[ -x ./install.sh ]] || { echo "install.sh is not executable"; exit 1; }

echo "[TEST] Checking presence of scripts..."
missing=0
for s in scripts/*.sh; do
  if [[ ! -f "$s" ]]; then
    echo "Missing script: $s"
    missing=1
  fi
done

[[ $missing -eq 0 ]] && echo "All expected scripts are present"
