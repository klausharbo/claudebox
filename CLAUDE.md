# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains `claudebox`, a macOS sandbox wrapper for Claude Code that provides secure, isolated execution. It's a shell script-based tool that:

- Creates dynamic macOS sandbox profiles for each project
- Automatically detects package managers (Homebrew, npm, nvm, fnm, nodenv, Nix, etc.)
- Restricts file system access to project directories only
- Blocks access to sensitive directories (`~/Documents`, `~/Desktop`, `~/.ssh`, etc.)

## Architecture

The project consists of three main files:

- `claudebox` - Main bash script (526 lines) with modular architecture
- `install.sh` - Installation script for user's `~/.local/bin`  
- `README.md` - Comprehensive documentation

### Core Components (`claudebox` script)

**Configuration & Environment (lines 22-112)**
- Error handling with traps and detailed error reporting
- Environment variable processing (`CLAUDEBOX_VERBOSE`, `CLAUDEBOX_DRY_RUN`, `CLAUDEBOX_CONFIG`)
- Config file loading from `~/.claudeboxrc`
- Early validation of sandbox-exec availability and permissions

**Path Detection System (lines 171-226)**
- Cached package manager detection (1-hour cache in `$TMPDIR`)
- Support for multiple package managers: Homebrew (ARM/Intel), npm, nvm, fnm, nodenv, Nix
- Parallel detection for performance optimization

**Sandbox Profile Generation (lines 227-434)**
- Dynamic profile creation using placeholder replacement
- Base profile with comprehensive macOS sandbox rules
- Template-based approach with `__PLACEHOLDER__` markers
- Automatic cleanup and validation

**Command Processing (lines 487-525)**
- Five main commands: `run` (default), `generate`, `profile`, `validate`, `help`
- Modular command dispatch with comprehensive logging

## Common Commands

```bash
# Run Claude Code in sandbox (default behavior)
./claudebox

# Generate sandbox profile only
./claudebox generate

# Validate generated profile
./claudebox validate

# Show profile location
./claudebox profile

# Debug mode with verbose output
CLAUDEBOX_VERBOSE=1 ./claudebox

# Dry run to see what would be executed
CLAUDEBOX_DRY_RUN=1 ./claudebox

# Install to user's PATH
./install.sh
```

## Configuration

The script supports configuration via:
- Environment variables (`CLAUDEBOX_*`)
- Config file at `~/.claudeboxrc` (bash format)
- Runtime command arguments

## Security Model

**Allowed Access:**
- Project directory (full read/write/execute)
- System binaries (`/usr`, `/bin`, `/sbin`, `/System`)
- Detected package manager paths
- Claude configuration (`~/.claude`, `~/.claude.json`)
- IDE configs (read-only): `.vscode`, `.cursor`, `.vim`, `.config`
- Temp directories and networking

**Blocked Access:**
- Personal directories: `~/Documents`, `~/Desktop`, `~/Downloads`
- Media folders: `~/Pictures`, `~/Movies`, `~/Music`
- Sensitive configs: `~/.ssh`, `~/.aws`, `~/.gnupg`, `~/.kube`

## Development Notes

- This is a defensive security tool - all modifications should maintain or enhance security
- The script uses comprehensive error handling with `set -euo pipefail`
- Path detection is cached for performance (1-hour TTL)
- Profile generation uses sed-based template replacement
- All temporary files are cleaned up via EXIT trap
- Sandbox profiles are validated before execution using `sandbox-exec -f profile true`