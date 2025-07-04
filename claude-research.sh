#!/bin/bash

set -euo pipefail

workdir="$(pwd)"
cd "$(dirname "$0")"

exec docker compose run --rm -w "$workdir" claude-code "$@"
