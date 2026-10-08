#!/usr/bin/env bash
set -euo pipefail
sleep 0.2
cat "$(dirname -- "$0")/report.json"
