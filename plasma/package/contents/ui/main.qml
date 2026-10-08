import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import "Io"
import "Commons" as Compat
PlasmoidItem {
    id: applet
    readonly property bool inPanel: Plasmoid.formFactor === PlasmaCore.Types.Horizontal || Plasmoid.formFactor === PlasmaCore.Types.Vertical
    preferredRepresentation: inPanel ? compactRepresentation : fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.StandardBackground
    toolTipMainText: "CodexBar"
    toolTipSubText: usage.barTooltip || (usage.errorMessage || "Codex subscription usage — click for details")

    // All applets share one source, outside the lazy popup.
    Component.onCompleted: UsageSource.registerClient(applet, Plasmoid.configuration.refreshIntervalSec)
    Component.onDestruction: UsageSource.unregisterClient(applet)
    Connections {
        target: Plasmoid.configuration
        function onRefreshIntervalSecChanged() {
            UsageSource.registerClient(applet, Plasmoid.configuration.refreshIntervalSec)
        }
    }
    UsagePanel {
        id: usage
        objectName: "codexbarUsage"
        parent: applet.fullRepresentationItem || applet
        anchors.fill: parent
        visible: applet.fullRepresentationItem !== null && (applet.expanded || !applet.inPanel)
        opened: applet.expanded || !applet.inPanel
        pollingEnabled: false
        usageSource: UsageSource
        report: UsageSource.report
        errorMessage: UsageSource.errorMessage
        pluginStale: UsageSource.pluginStale
        loading: UsageSource.loading
        notInstalled: UsageSource.notInstalled
        bundledCmd: Native.localFile(Qt.resolvedUrl("../code/codexbar"))
        settings: ({
            refreshIntervalSec: Plasmoid.configuration.refreshIntervalSec,
            showLabel: Plasmoid.configuration.showLabel,
            showRemaining: Plasmoid.configuration.showRemaining,
            colorMode: Plasmoid.configuration.colorMode,
            barWindow: Plasmoid.configuration.barWindow
        })
        bar: ({vertical: applet.Plasmoid.formFactor === PlasmaCore.Types.Vertical,
               foreground: Compat.Color.foreground, barForeground: Compat.Color.foreground,
               background: Compat.Color.background, urgent: Compat.Color.urgent,
               fontFamily: Compat.Style.font.family, transparent: false})
        onCloseRequested: applet.expanded = false
    }

    compactRepresentation: Item {
        // Plasma panel layouts use attached size hints, not implicitWidth alone.
        Layout.minimumWidth: implicitWidth
        Layout.preferredWidth: implicitWidth
        Layout.maximumWidth: implicitWidth
        Layout.minimumHeight: implicitHeight
        Layout.preferredHeight: implicitHeight
        implicitWidth: row.implicitWidth + 12
        implicitHeight: Kirigami.Units.iconSizes.small
        Row {
            id: row
            anchors.centerIn: parent
            spacing: 5
            Kirigami.Icon {
                source: Qt.resolvedUrl("assets/openai.svg")
                isMask: true
                color: usage.barColor
                width: Kirigami.Units.iconSizes.small
                height: width
            }
            Text {
                visible: text !== ""
                text: usage.barLabel
                textFormat: Text.PlainText
                color: usage.barColor
                font: Kirigami.Theme.defaultFont
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                visible: usage.barStale
                text: "Ⅱ"
                color: usage.dim
                font: Kirigami.Theme.defaultFont
                anchors.verticalCenter: parent.verticalCenter
            }
            Rectangle {
                visible: usage.hasCriticalOther
                width: 5
                height: width
                radius: width / 2
                color: usage.criticalDotColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            cursorShape: Qt.PointingHandCursor
            onClicked: function(event) {
                if (event.button === Qt.MiddleButton) usage.refresh(true)
                else applet.expanded = !applet.expanded
            }
        }
    }

    fullRepresentation: Item {
        Layout.minimumWidth: 260
        Layout.minimumHeight: Math.ceil(usage.implicitHeight)
        Layout.preferredWidth: 320
        Layout.preferredHeight: Math.max(Layout.minimumHeight, usage.implicitHeight)
    }
}
