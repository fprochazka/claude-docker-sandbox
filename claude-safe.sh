#!/bin/bash

set -euo pipefail

PWD="$(pwd)"
cd "$(dirname "$0")"

# Set default environment variables if not already set
export PWD
export PUID="${PUID:-$(id -u)}"
export PGID="${PGID:-$(id -g)}"
export CONTAINER_USER="${CONTAINER_USER:-$(whoami)}"
export CONTAINER_GROUP="${CONTAINER_GROUP:-$(id -gn)}"

exec docker compose run --rm -w "$PWD" claude-code "$@"
