import QtQuick
Rectangle {
    property color foreground: "white"
    property bool hasCursor: false
    color: hasCursor ? Qt.rgba(foreground.r, foreground.g, foreground.b, 0.12) : "transparent"
    radius: 5
}
