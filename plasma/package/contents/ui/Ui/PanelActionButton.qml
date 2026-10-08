import QtQuick
import QtQuick.Controls as Controls
import "../Commons" as Compat
Rectangle {
    id: root
    property real size: 24
    property var borderSpec: ({color: "transparent", width: 0})
    property string iconText: ""
    property string tooltipText: ""
    property color foreground: Compat.Color.foreground
    property color hoverColor: foreground
    property string fontFamily: Compat.Style.font.family
    property real fontSize: Compat.Style.font.bodySmall
    readonly property bool _hot: hover.hovered
    signal clicked()
    color: "transparent"
    implicitWidth: size
    implicitHeight: size
    width: size
    height: size
    border.color: borderSpec.color
    border.width: borderSpec.width
    Text {
        anchors.centerIn: parent
        text: root.iconText
        color: root._hot ? root.hoverColor : root.foreground
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
    }
    HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }
    TapHandler { onTapped: root.clicked() }
    Controls.ToolTip.visible: _hot && tooltipText !== ""
    Controls.ToolTip.text: tooltipText
}
