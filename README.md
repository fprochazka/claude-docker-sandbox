# Claude Docker Sandbox

A containerized environment for running Claude Code CLI with all permissions enabled in a safe, isolated setting.

## Overview

This project provides a Docker-based sandbox for safely running Claude Code CLI with full permissions without exposing your host system. The container isolation allows you to grant Claude Code broad access while maintaining system security.

## Components

- **Dockerfile**: Ubuntu 22.04-based container with Claude Code CLI, Node.js 20, and Google Cloud CLI
- **entrypoint.sh**: Container initialization script that creates user with matching host UID/GID
- **claude-safe.sh**: Wrapper script for easy container execution that preserves working directory

## Features

- Isolated execution environment with Docker containerization
- Pre-configured development tools (Node.js 20, Git, Google Cloud CLI)
- Automatic user creation with matching host UID/GID for seamless file permissions
- Current working directory preservation - runs from wherever you invoke it
- Volume mounts for persistent workspace access
- Google Cloud and Anthropic API credential integration
- Safe environment for running Claude Code with `--dangerously-skip-permissions`

## Installation

1. Clone this repository:
   ```bash
   git clone <repository-url> ~/tools/claude-docker-sandbox
   cd ~/tools/claude-docker-sandbox
   ```

2. Make the wrapper script executable:
   ```bash
   chmod +x claude-safe.sh
   ```

3. Create an alias for easy access (add to your `.bashrc` or `.zshrc`):
   ```bash
   echo 'alias claude-safe="~/tools/claude-docker-sandbox/claude-safe.sh"' >> ~/.bashrc
   source ~/.bashrc
   ```

## Usage

Run Claude Code in the safe container from any directory:
```bash
claude-safe [claude-code-arguments]
```

Or directly:
```bash
./claude-safe.sh [claude-code-arguments]
```

The container will automatically build on first use and preserve your current working directory.

## Environment Variables

### Claude Code Configuration
- `CLAUDE_CODE_USE_VERTEX`: Enable Vertex AI integration
- `CLOUD_ML_REGION`: Google Cloud region for ML services  
- `ANTHROPIC_VERTEX_PROJECT_ID`: Google Cloud project ID for Anthropic services

### Volume Mounts
The script automatically mounts:
- Current working directory (`$(pwd)`) to the same path in container
- `$HOME/.config/gcloud` (read-only) for Google Cloud credentials
- `$HOME/.config/anthropic` (read-only) for Anthropic API credentials  
- `$HOME/.claude` for Claude configuration

## Security Considerations

The container provides safe isolation while allowing full Claude Code permissions:
- User isolation (non-root execution)
- Containerized file system access
- Host system protection through Docker isolation
- Read-only credential mounting

## Prerequisites

- Docker
- Google Cloud credentials (if using Vertex AI)
- Anthropic API credentials
