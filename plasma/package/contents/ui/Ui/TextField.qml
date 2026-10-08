import QtQuick
import QtQuick.Controls as Controls
import "../Commons"
Controls.TextField {
    property color foreground: Color.foreground
    color: foreground
    font.family: Style.font.family
    font.pixelSize: Style.font.bodySmall
    selectByMouse: true
}
