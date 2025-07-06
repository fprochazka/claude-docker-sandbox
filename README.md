# Claude Docker Sandbox

A containerized environment for running Claude Code CLI with `--dangerously-skip-permissions` (all permissions enabled) in a safe, isolated setting.

## Features

- Isolated execution environment with Docker containerization
- Pre-configured development tools (Node.js 20, Git, Google Cloud CLI)
- Automatic user creation with matching host UID/GID for seamless file permissions
- Current working directory preservation - runs from wherever you invoke it
- Google Cloud and Anthropic API credential integration

## Prerequisites

- Docker
- Google Cloud credentials (if using Vertex AI)
- Anthropic API credentials

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

Should pass all ENVs from https://docs.anthropic.com/en/docs/claude-code/settings to the docker container

### Volume Mounts

The script automatically mounts:
- Current working directory (`$(pwd)`) to the same path in container
- `$HOME/.config/gcloud` for Google Cloud credentials
- `$HOME/.config/anthropic` for Anthropic API credentials  
- `$HOME/.claude` for Claude configuration
