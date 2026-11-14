#!/usr/bin/env bash
set +x
set -euo pipefail

if [[ $# -ne 1 || ! $1 =~ ^[a-z0-9]([-a-z0-9]*[a-z0-9])?$ || ${#1} -gt 63 ]]; then
  printf 'Usage: bash k8s/create-db-secret.sh <namespace>\n' >&2
  exit 2
fi

username_suffix=$(openssl rand -hex 8)
password=$(openssl rand -hex 32)
[[ $username_suffix =~ ^[a-f0-9]{16}$ && $password =~ ^[a-f0-9]{64}$ ]]

printf 'type=postgresql\nprovider=postgresql\nhost=demo-db\nport=5432\ndatabase=petclinic\nusername=demo_%s\npassword=%s\n' \
  "$username_suffix" "$password" |
  kubectl --namespace "$1" create secret generic demo-db \
    --type=servicebinding.io/postgresql --from-env-file=/dev/stdin
