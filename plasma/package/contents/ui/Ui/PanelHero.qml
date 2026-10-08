import QtQuick
import "../Commons" as Compat
Item {
    id: root
    property string title: ""
    property string meta: ""
    property color foreground: Compat.Color.foreground
    property string fontFamily: Compat.Style.font.family
    property Component iconComponent
    implicitHeight: Math.max(icon.height, labels.implicitHeight)
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 8
        Loader { id: icon; sourceComponent: root.iconComponent; anchors.verticalCenter: parent.verticalCenter }
        Row {
            id: labels
            spacing: 8
            Text { text: root.title; textFormat: Text.PlainText; color: root.foreground; font.family: root.fontFamily; font.pixelSize: 24 }
            Text { visible: text !== ""; text: root.meta.toUpperCase(); textFormat: Text.PlainText; color: root.foreground; opacity: 0.65; font.family: root.fontFamily; font.pixelSize: Compat.Style.font.caption; anchors.verticalCenter: parent.verticalCenter }
        }
    }
}
