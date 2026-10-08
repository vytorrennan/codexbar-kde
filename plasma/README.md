# CodexBar for KDE Plasma 6

A Plasma adaptation of codexbar 0.8.1. The original Bash CLI and Omarchy
files remain intact. This port uses the same schema-version-2 report and reuses
the original panel's gauges, pacing, credits, reset countdowns, and stale-data
handling. Plasma supplies the popup, theme, settings, and panel placement.

## Install and use

From the repository root:

```sh
make install-plasma
```

Add **CodexBar** with KDE's **Add Widgets** picker. It can live on a panel or
desktop. To open a standalone window:

```sh
plasmawindowed org.local.codexbar
```

- Left click: open the usage popup.
- Middle click: force a fresh usage request.
- Right click: open KDE's widget context menu.
- Refresh control or R in the popup: force a refresh.
- Escape: close the popup. Arrow keys scroll long reports.

The widget polls in the background even before its popup is opened. The default
interval is five minutes; the original CLI's 60-second API cache still applies.
Multiple widgets in the same Plasma session share one polling timer and report.
The shortest configured interval wins, while each widget keeps its own display
settings. Requests during an in-flight refresh are coalesced.
Right-click the widget and choose **Configure CodexBar** to change the interval,
usage window, colors, label visibility, or remaining-allowance display.

The bundled CLI is used if `codexbar` cannot start from PATH. A running CLI that
returns an error does not cause a fallback. The existing Codex login is used
through the original CLI, including its normal token-refresh behavior. Credentials
are never handed to the QML interface. Usage cache behavior is unchanged.

## Requirements and validation

Plasma 6, Kirigami, Qt 6 development headers, qmake6, make, a C++ compiler, and
the original CLI's bash/curl/jq/GNU coreutils requirements. Tests also need Qt
Quick Test (`qmltestrunner`). No Quickshell or Hyprland is required.

```sh
./plasma/build.sh
./plasma/test.sh
bash tests/run_all.sh
```

The Plasma tests use synthetic reports and mock commands; they do not access
your credentials or network. They cover gauges, settings, failed-start fallback,
empty output, schema errors, and preservation of the last good report.

The native QML helper must be rebuilt after an incompatible Qt update. Close
running widget instances before updating the helper, then reinstall.

Installed package: `~/.local/share/plasma/plasmoids/org.local.codexbar/`.
The panel defaults to the remaining percentage; the popup continues to show usage consumed.
Its minimum height follows the content so shrinking it does not introduce a scrollbar.

Remove widget instances first, then use `make uninstall-plasma` to uninstall.

## Attribution

Original codexbar and panel: mryll, MIT; see the repository [LICENSE](../LICENSE).
The SVG OpenAI mark comes from the OpenUsage project. Its MIT notice is retained in
`package/contents/ui/assets/LICENSE.OpenUsage`.
