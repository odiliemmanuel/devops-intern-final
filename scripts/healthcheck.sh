#!/usr/bin/env bash
set -euo pipefail

URL="${1:-http://localhost:8080}"

if ! command -v curl >/dev/null 2>&1; then
  echo "ERROR: curl is required but not installed" >&2
  exit 2
fi

# curl prints 000 as the status code when it cannot connect at all
status=$(curl -s -o /dev/null -w '%{http_code}' --max-time 5 "$URL" || true)

if [ "$status" = "200" ]; then
  echo "OK: $URL returned HTTP 200"
  exit 0
fi

echo "FAIL: $URL returned HTTP $status (expected 200)" >&2
exit 1