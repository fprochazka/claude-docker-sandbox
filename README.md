# Claude Safe Research

A containerized environment for running Claude Code CLI with all permissions enabled in a safe, isolated setting.

## Overview

This project provides a Docker-based sandbox for safely running Claude Code CLI with full permissions without exposing your host system. The container isolation allows you to grant Claude Code broad access while maintaining system security.

## Components

- **Dockerfile**: Ubuntu 22.04-based container with Claude Code CLI, Node.js, and Google Cloud CLI
- **docker-compose.yml**: Service configuration with volume mounts for development workspace and credentials
- **claude-research.sh**: Wrapper script for easy container execution
- **settings.local.json**: Claude Code permissions configuration for controlled access

## Features

- Isolated execution environment
- Pre-configured development tools (Node.js, Git, Google Cloud CLI)
- Volume mounts for persistent workspace access
- Google Cloud and Anthropic API integration
- Safe environment for running Claude Code with full permissions

## Installation

1. Clone this repository:
   ```bash
   git clone <repository-url> ~/tools/claude-safe-research
   cd ~/tools/claude-safe-research
   ```

2. Make the wrapper script executable:
   ```bash
   chmod +x claude-research.sh
   ```

3. Build the container:
   ```bash
   docker compose build
   ```

4. Create an alias for easy access (add to your `.bashrc` or `.zshrc`):
   ```bash
   echo 'alias claude-safe="~/tools/claude-safe-research/claude-research.sh"' >> ~/.bashrc
   source ~/.bashrc
   ```

## Usage

Run Claude Code in the safe container:
```bash
claude-safe [claude-code-arguments]
```

Or directly:
```bash
./claude-research.sh [claude-code-arguments]
```

## Environment Variables

- `CLAUDE_CODE_USE_VERTEX`: Enable Vertex AI integration
- `CLOUD_ML_REGION`: Google Cloud region for ML services  
- `ANTHROPIC_VERTEX_PROJECT_ID`: Google Cloud project ID for Anthropic services

## Security Considerations

The container provides safe isolation while allowing full Claude Code permissions:
- User isolation (non-root execution)
- Containerized file system access
- Host system protection through Docker isolation
- Read-only credential mounting

## Prerequisites

- Docker and Docker Compose
- Google Cloud credentials (if using Vertex AI)
- Anthropic API credentials