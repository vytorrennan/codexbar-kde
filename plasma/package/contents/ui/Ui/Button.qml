import QtQuick
import QtQuick.Controls as Controls
import "../Commons"
Controls.Button {
    property real fontSize: Style.font.bodySmall
    property color foreground: Color.foreground
    property string fontFamily: Style.font.family
    property bool bordered: false
    property bool hasCursor: false
    font.family: fontFamily
    font.pixelSize: fontSize
    palette.buttonText: foreground
    highlighted: hasCursor
}
