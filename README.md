# CodexBar for KDE Plasma 6

A KDE Plasma port of [mryll/codexbar](https://github.com/mryll/codexbar), built for CachyOS KDE and other Plasma 6 desktops. No Omarchy, Hyprland, or Quickshell is required.

The panel shows the **percentage remaining** by default. The popup shows **percentage used**, reset countdowns, pacing, credits when available, and the last update time. The compact popup has a minimum height based on its content, so it can shrink without introducing a scrollbar.

## Install

Requires Plasma 6, Kirigami, Qt 6 QML/Quick development files, `qmake6`, `make`, a C++ compiler, Bash, curl, jq, and GNU coreutils. On CachyOS/Arch with KDE already installed, the build and CLI dependencies can be installed with:

```sh
sudo pacman -S --needed base-devel qt6-base qt6-declarative kirigami curl jq
```

Use your existing Codex CLI login, or run `codex login` first. Then:

```sh
git clone https://github.com/vytorrennan/codexbar-kde.git
cd codexbar-kde
make install-plasma
```

Right-click the KDE panel, enter edit mode, choose **Add Widgets**, and add **CodexBar**. Installation is per user and does not replace desktop or panel settings.

For a standalone window:

```sh
plasmawindowed org.local.codexbar
```

## Controls and settings

- **Left click:** open or close the usage popup.
- **Middle click:** force a refresh.
- **Right click:** KDE's widget context menu, including **Configure CodexBar**.
- **Refresh button / R:** refresh from the popup.
- **Escape:** close the popup.

The default refresh interval is **300 seconds (five minutes)**. Configure CodexBar to choose the interval, session/weekly/review/worst window, colors, label visibility, or whether the panel shows remaining or used percentage. The popup always shows usage consumed.

The widget polls even when the popup is closed. It prefers `codexbar` from PATH, falling back to the bundled CLI only if that executable cannot start. The original CLI's 60-second API cache and token-refresh behavior are preserved. Authentication stays in the CLI; credentials are not passed into QML.

To update, close widget instances, pull the latest changes, and run `make install-plasma` again. Plasma may retain old QML until the widget or Plasma shell is restarted. The native helper must be rebuilt after incompatible Qt updates.

To uninstall, remove widget instances and run:

```sh
make uninstall-plasma
```

## Validation

```sh
./plasma/build.sh
./plasma/test.sh
env -u NO_COLOR bash tests/run_all.sh
```

Plasma tests use synthetic reports and mock commands without accessing your credentials or network. They cover display settings, remaining percentage with unchanged popup usage, native process fallback, operational failures, schema errors, retaining the last good report, and content sizing. `qmltestrunner` is required. The CLI suite includes color checks, so the command above clears any inherited `NO_COLOR` setting.

## Source and attribution

- The original Bash CLI and Omarchy QML are retained under `codexbar` and `omarchy/` for provenance and upstream tests.
- The KDE package, compatibility components, and native QML helper are under `plasma/`.
- Original codexbar: mryll, MIT. See [LICENSE](LICENSE).
- OpenAI mark: [OpenUsage](https://github.com/robinebers/openusage), with its MIT notice retained in [LICENSE.OpenUsage](plasma/package/contents/ui/assets/LICENSE.OpenUsage).

This is an independent community port, not an official OpenAI application.
