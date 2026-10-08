import QtQuick
import "../Commons" as Compat
Text {
    property color foreground: Compat.Color.foreground
    property string fontFamily: Compat.Style.font.family
    textFormat: Text.PlainText
    color: foreground
    opacity: 0.65
    font.family: fontFamily
    font.pixelSize: Compat.Style.font.caption
    font.letterSpacing: 1
}
