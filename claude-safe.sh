#!/bin/bash

if [[ "${DEBUG:-false}" == "true" ]]; then
    set -euxo pipefail
else
    set -euo pipefail
fi

# Image version - increment to force rebuild
IMAGE_TAG="v1.2"
IMAGE_NAME="claude-docker-sandbox:${IMAGE_TAG}"
SCRIPT_DIR="$(dirname "$0")"

# Set default environment variables if not already set
export PUID="${PUID:-$(id -u)}"
export PGID="${PGID:-$(id -g)}"
export CONTAINER_USER="${CONTAINER_USER:-$(whoami)}"
export CONTAINER_GROUP="${CONTAINER_GROUP:-$(id -gn)}"

# Function to get environment variables starting with given prefixes
get_env_vars() {
    local env_args=""
    while IFS='=' read -r key value; do
        if [[ $key =~ ^(GOOGLE_CLOUD_|ANTHROPIC_|CLAUDE_CODE_|CLOUD_) ]]; then
            env_args+=" -e \"${key}=${value}\""
        fi
    done < <(env)
    echo "$env_args"
}

# Build the image if it doesn't exist
if ! docker image inspect "${IMAGE_NAME}" >/dev/null 2>&1; then
    echo "Building ${IMAGE_NAME}..."
    docker build -t "${IMAGE_NAME}" "${SCRIPT_DIR}"
    echo ""
fi

# Get environment variables
ENV_ARGS=$(get_env_vars)

# Run the container
# shellcheck disable=SC2086
eval "exec docker run --rm -it \
  -w \"$(pwd)\" \
  -v \"$(pwd):$(pwd)\" \
  -v \"${HOME}/.config/gcloud:${HOME}/.config/gcloud\" \
  -v \"${HOME}/.config/anthropic:${HOME}/.config/anthropic\" \
  -v \"${HOME}/.claude:${HOME}/.claude\" \
  -e \"PUID=${PUID}\" \
  -e \"PGID=${PGID}\" \
  -e \"CONTAINER_USER=${CONTAINER_USER}\" \
  -e \"CONTAINER_GROUP=${CONTAINER_GROUP}\" \
  ${ENV_ARGS} \
  \"${IMAGE_NAME}\" \"\$@\""
