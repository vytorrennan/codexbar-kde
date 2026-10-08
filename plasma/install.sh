#!/usr/bin/env bash
set -euo pipefail
task_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
"$task_dir/build.sh"
if kpackagetool6 --type Plasma/Applet --show org.local.codexbar >/dev/null 2>&1; then
    kpackagetool6 --type Plasma/Applet --upgrade "$task_dir/package"
else
    kpackagetool6 --type Plasma/Applet --install "$task_dir/package"
fi
