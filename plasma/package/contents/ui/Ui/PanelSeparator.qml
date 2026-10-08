import QtQuick
Rectangle {
    property color foreground: "white"
    implicitHeight: 1
    width: parent.width
    color: Qt.rgba(foreground.r, foreground.g, foreground.b, 0.12)
}
