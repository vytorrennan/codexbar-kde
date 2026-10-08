#!/usr/bin/env bash
set -euo pipefail
task_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
install -Dm755 "$task_dir/../codexbar" "$task_dir/package/contents/code/codexbar"
cd "$task_dir/native"
qmake6 io.pro
make -j2
