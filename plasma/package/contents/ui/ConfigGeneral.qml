import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
Kirigami.FormLayout {
    id: root
    property alias cfg_refreshIntervalSec: refresh.value
    property alias cfg_showLabel: label.checked
    property alias cfg_showRemaining: remaining.checked
    property string cfg_colorMode: "full"
    property string cfg_barWindow: "Session"
    SpinBox { id: refresh; Kirigami.FormData.label: "Refresh interval (seconds):"; from: 60; to: 3600; stepSize: 30; editable: true }
    CheckBox { id: label; text: "Show usage next to the panel icon" }
    CheckBox { id: remaining; text: "Show remaining percentage on the panel" }
    ComboBox {
        Kirigami.FormData.label: "Colors:"
        model: ["full", "none", "bar-only", "panel-only"]
        currentIndex: model.indexOf(root.cfg_colorMode)
        onActivated: root.cfg_colorMode = currentText
    }
    ComboBox {
        Kirigami.FormData.label: "Panel usage window:"
        model: ["Session", "Weekly", "Review", "Worst"]
        currentIndex: model.indexOf(root.cfg_barWindow)
        onActivated: root.cfg_barWindow = currentText
    }
}
