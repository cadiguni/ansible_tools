#!/usr/bin/env bash
# Lint + dry-run (check mode) sem alterar nada no sistema.
set -euo pipefail

cd "$(dirname "$0")/.."

yamllint . || true
ansible-lint || true

ansible-playbook \
  -i inventory/local.yml \
  playbooks/workstation.yml \
  --check --diff --ask-become-pass "$@"
