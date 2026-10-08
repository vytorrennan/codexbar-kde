#!/usr/bin/env bash
set -euo pipefail
task_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
QT_FORCE_STDERR_LOGGING=1 QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=software \
    /usr/lib/qt6/bin/qmltestrunner -input "$task_dir/tests"
