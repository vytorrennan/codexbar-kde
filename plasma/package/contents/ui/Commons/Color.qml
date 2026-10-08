pragma Singleton
import QtQuick
import org.kde.kirigami as Kirigami
QtObject {
    readonly property color foreground: Kirigami.Theme.textColor
    readonly property color background: Kirigami.Theme.backgroundColor
    readonly property color accent: Kirigami.Theme.highlightColor
    readonly property color urgent: Kirigami.Theme.negativeTextColor
    readonly property var popups: ({background: background, text: foreground})
}
