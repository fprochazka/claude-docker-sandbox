#!/usr/bin/env bash

if [[ "${DEBUG:-false}" == "true" ]]; then
    set -euxo pipefail
else
    set -euo pipefail
fi

# Image version - increment to force rebuild
IMAGE_TAG="v1.3"
IMAGE_NAME="claude-docker-sandbox:${IMAGE_TAG}"
SCRIPT_DIR="$(dirname "$0")"

# Build the image if it doesn't exist
if ! docker image inspect "${IMAGE_NAME}" >/dev/null 2>&1; then
    echo "Building ${IMAGE_NAME}..."
    docker build -t "${IMAGE_NAME}" "${SCRIPT_DIR}"
    echo ""
fi

# Detect OS
OS="$(uname -s)"

# Set default environment variables if not already set
export PUID="${PUID:-$(id -u)}"
export PGID="${PGID:-$(id -g)}"
export CONTAINER_USER="${CONTAINER_USER:-$(whoami)}"
export CONTAINER_GROUP="${CONTAINER_GROUP:-$(id -gn)}"

# Set config paths based on OS
if [[ "$OS" == "Darwin" ]]; then
    # macOS paths
    GCLOUD_CONFIG_PATH="${HOME}/Library/Application Support/gcloud"
    ANTHROPIC_CONFIG_PATH="${HOME}/Library/Application Support/anthropic"
    CLAUDE_CONFIG_PATH="${HOME}/Library/Application Support/claude"
    # Fallback to .config if Library paths don't exist
    if [[ ! -d "$GCLOUD_CONFIG_PATH" && -d "${HOME}/.config/gcloud" ]]; then
        GCLOUD_CONFIG_PATH="${HOME}/.config/gcloud"
    fi
    if [[ ! -d "$ANTHROPIC_CONFIG_PATH" && -d "${HOME}/.config/anthropic" ]]; then
        ANTHROPIC_CONFIG_PATH="${HOME}/.config/anthropic"
    fi
    if [[ ! -d "$CLAUDE_CONFIG_PATH" && -d "${HOME}/.claude" ]]; then
        CLAUDE_CONFIG_PATH="${HOME}/.claude"
    fi
else
    # Linux paths
    GCLOUD_CONFIG_PATH="${HOME}/.config/gcloud"
    ANTHROPIC_CONFIG_PATH="${HOME}/.config/anthropic"
    CLAUDE_CONFIG_PATH="${HOME}/.claude"
fi

# Function to get environment variables starting with given prefixes
get_env_vars() {
    local env_args=""
    while IFS='=' read -r key value; do
        if [[ $key =~ ^(GOOGLE_|CLOUD_|ANTHROPIC_|CLAUDE_|MCP_|BASH_|DISABLE_|HTTP_PROXY|HTTPS_PROXY|MAX_THINKING_TOKENS|MAX_MCP_OUTPUT_TOKENS) ]]; then
            env_args+=" -e \"${key}=${value}\""
        fi
    done < <(env)
    echo "$env_args"
}

# Get environment variables
ENV_ARGS=$(get_env_vars)

# Run the container
# shellcheck disable=SC2086
eval "exec docker run --rm -it \
  -w \"$(pwd)\" \
  -v \"$(pwd):$(pwd)\" \
  -v \"${GCLOUD_CONFIG_PATH}:${HOME}/.config/gcloud\" \
  -v \"${ANTHROPIC_CONFIG_PATH}:${HOME}/.config/anthropic\" \
  -v \"${CLAUDE_CONFIG_PATH}:${HOME}/.claude\" \
  -e \"PUID=${PUID}\" \
  -e \"PGID=${PGID}\" \
  -e \"CONTAINER_USER=${CONTAINER_USER}\" \
  -e \"CONTAINER_GROUP=${CONTAINER_GROUP}\" \
  ${ENV_ARGS} \
  \"${IMAGE_NAME}\" \"\$@\""
