import QtQuick
import QtQuick.Controls as Controls
import "../Commons" as Compat
Controls.TextField {
    property color foreground: Compat.Color.foreground
    color: foreground
    font.family: Compat.Style.font.family
    font.pixelSize: Compat.Style.font.bodySmall
    selectByMouse: true
}
