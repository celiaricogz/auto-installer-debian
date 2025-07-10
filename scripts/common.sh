#!/bin/bash
set -euo pipefail

# Ruta base del proyecto (donde está install.sh)
current_path="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Ruta de carpetas internas
scripts_path="$current_path/scripts"
config_path="$current_path/config"
resources_path="$current_path/resources"
backup_path="$current_path/backup"
logs_path="$current_path/logs"
flags_path="$current_path/flags"

# Crear carpetas si no existen
mkdir -p "$logs_path" "$flags_path" "$backup_path"
