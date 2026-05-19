#!/usr/bin/env bash
set -euo pipefail

ansible-galaxy collection install -r requirements.yml

ansible-playbook \
  -i inventory/local.yml \
  playbooks/workstation.yml \
  --ask-become-pass
