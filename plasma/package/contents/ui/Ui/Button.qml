import QtQuick
import QtQuick.Controls as Controls
import "../Commons" as Compat
Controls.Button {
    property real fontSize: Compat.Style.font.bodySmall
    property color foreground: Compat.Color.foreground
    property string fontFamily: Compat.Style.font.family
    property bool bordered: false
    property bool hasCursor: false
    font.family: fontFamily
    font.pixelSize: fontSize
    palette.buttonText: foreground
    highlighted: hasCursor
}
