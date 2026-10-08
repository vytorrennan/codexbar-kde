import QtQuick
import "../Commons"
Text {
    property color foreground: Color.foreground
    property string fontFamily: Style.font.family
    textFormat: Text.PlainText
    color: foreground
    opacity: 0.65
    font.family: fontFamily
    font.pixelSize: Style.font.caption
    font.letterSpacing: 1
}
