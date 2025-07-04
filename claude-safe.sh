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

# Build the image if it doesn't exist
if ! docker image inspect claude-docker-sandbox:latest >/dev/null 2>&1; then
    echo "Building claude-docker-sandbox:latest..."
    docker build -t claude-docker-sandbox:latest .
    echo ""
fi

# Run the container
exec docker run --rm -it \
  -w "$PWD" \
  -v "${PWD}:${PWD}" \
  -v "${HOME}/.config/gcloud:${HOME}/.config/gcloud:ro" \
  -v "${HOME}/.config/anthropic:${HOME}/.config/anthropic:ro" \
  -v "${HOME}/.claude:${HOME}/.claude" \
  -e "PUID=${PUID}" \
  -e "PGID=${PGID}" \
  -e "CONTAINER_USER=${CONTAINER_USER}" \
  -e "CONTAINER_GROUP=${CONTAINER_GROUP}" \
  -e "GOOGLE_APPLICATION_CREDENTIALS=${HOME}/.config/gcloud/application_default_credentials.json" \
  -e "CLAUDE_CODE_USE_VERTEX=${CLAUDE_CODE_USE_VERTEX}" \
  -e "CLOUD_ML_REGION=${CLOUD_ML_REGION}" \
  -e "ANTHROPIC_VERTEX_PROJECT_ID=${ANTHROPIC_VERTEX_PROJECT_ID}" \
  claude-docker-sandbox:latest "$@"
