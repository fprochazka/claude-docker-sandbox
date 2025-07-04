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
HOME_DIR="/home/$USERNAME"
if ! getent passwd "$USER_ID" > /dev/null 2>&1; then
    if [ -d "$HOME_DIR" ]; then
        # Home directory already exists (mounted), create user without home directory creation
        useradd -u "$USER_ID" -g "$GROUP_ID" -d "$HOME_DIR" -M -s /bin/bash "$USERNAME"
    else
        # Home directory doesn't exist, create user with home directory
        useradd -u "$USER_ID" -g "$GROUP_ID" -d "$HOME_DIR" -m -s /bin/bash "$USERNAME"
    fi
fi

# Only chown home directory if it was created by us (not mounted)
if ! mountpoint -q "$HOME_DIR" 2>/dev/null; then
    chown "$USER_ID:$GROUP_ID" "$HOME_DIR"
fi

# Switch to the created user and execute the command
exec gosu "$USER_ID:$GROUP_ID" "$@"
