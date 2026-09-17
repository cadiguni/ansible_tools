#!/usr/bin/env bash
# Configura a workstation local. Aceita tags extras: ./scripts/run-local.sh --tags dev
set -euo pipefail

cd "$(dirname "$0")/.."

command -v ansible-playbook >/dev/null || {
  echo "ansible nao encontrado. Rode primeiro o playbooks/bootstrap.yml ou instale via gerenciador da distro." >&2
  exit 1
}

ansible-galaxy collection install -r requirements.yml

exec ansible-playbook \
  -i inventory/local.yml \
  playbooks/workstation.yml \
  --ask-become-pass \
  "$@"
