#!/usr/bin/env bash
set -euo pipefail

echo "=== System information ==="
echo "User:       $(id -un) (effective UID: $(id -u))"
echo "Hostname:   $(hostname)"
echo "Kernel:     $(uname -r)"
echo "Date (UTC): $(date -u +%Y-%m-%dT%H:%M:%SZ)"

echo
echo "=== Disk usage (human-readable) ==="
df -h /

echo
echo "=== Memory usage ==="
free -h

echo
echo "=== Docker daemon ==="
if command -v docker >/dev/null 2>&1; then
  if docker info >/dev/null 2>&1; then
    echo "running"
  else
    echo "docker CLI installed, but the daemon is not reachable"
  fi
else
  echo "docker CLI not installed"
fi