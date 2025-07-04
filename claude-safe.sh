#!/bin/bash

set -euo pipefail

# Image version - increment to force rebuild
IMAGE_TAG="v1.2"
IMAGE_NAME="claude-docker-sandbox:${IMAGE_TAG}"
SCRIPT_DIR="$(dirname "$0")"

# Set default environment variables if not already set
export PUID="${PUID:-$(id -u)}"
export PGID="${PGID:-$(id -g)}"
export CONTAINER_USER="${CONTAINER_USER:-$(whoami)}"
export CONTAINER_GROUP="${CONTAINER_GROUP:-$(id -gn)}"

# Build the image if it doesn't exist
if ! docker image inspect "${IMAGE_NAME}" >/dev/null 2>&1; then
    echo "Building ${IMAGE_NAME}..."
    docker build -t "${IMAGE_NAME}" "${SCRIPT_DIR}"
    echo ""
fi

# Run the container
exec docker run --rm -it \
  -w "$(pwd)" \
  -v "$(pwd):$(pwd)" \
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
  "${IMAGE_NAME}" "$@"
