#!/bin/bash

set -euo pipefail

# Get user/group IDs from environment or use defaults
USER_ID=${PUID:-1000}
GROUP_ID=${PGID:-1000}
USERNAME=${CONTAINER_USER:-user}
GROUPNAME=${CONTAINER_GROUP:-user}

# Create group if it doesn't exist
if ! getent group "$GROUP_ID" > /dev/null 2>&1; then
    groupadd -g "$GROUP_ID" "$GROUPNAME"
fi

# Create user if it doesn't exist
if ! getent passwd "$USER_ID" > /dev/null 2>&1; then
    useradd -u "$USER_ID" -g "$GROUP_ID" -d "/home/$USERNAME" -m -s /bin/bash "$USERNAME"
fi

# Ensure home directory exists and has correct permissions
HOME_DIR="/home/$USERNAME"
if [ ! -d "$HOME_DIR" ]; then
    mkdir -p "$HOME_DIR"
fi
chown "$USER_ID:$GROUP_ID" "$HOME_DIR"

# Switch to the created user and execute the command
exec gosu "$USER_ID:$GROUP_ID" "$@"
