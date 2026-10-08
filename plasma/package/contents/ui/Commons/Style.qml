pragma Singleton
import QtQuick
import org.kde.kirigami as Kirigami
import "../Io"
QtObject {
    readonly property string family: Native.resolveFont(Kirigami.Theme.defaultFont.family)
    readonly property var font: ({family: family, caption: 12, body: 14, bodySmall: 13, subtitle: 16, heading: 25, title: 30, display: 32})
    readonly property var spacing: ({xs: 3, sm: 5, md: 8, lg: 12, xl: 16, rowPaddingX: 15, panelGap: 16, popupRowHeight: 38, controlHeight: 32, labelGap: 5})
    readonly property int cornerRadius: 10
    function space(n) { return Math.round(n) }
    function spaceReal(n) { return n }
    function duration(n) { return n }
    function selectedFillFor(foreground, accent, urgent) { return Qt.rgba(foreground.r, foreground.g, foreground.b, 0.12) }
    function colorFromHex(value, fallback) {
        if (!/^#[0-9a-f]{6}([0-9a-f]{2})?$/i.test(value)) return fallback;
        var hex = value.substring(1);
        var alpha = hex.length === 8 ? parseInt(hex.substring(0, 2), 16) / 255 : 1;
        if (hex.length === 8) hex = hex.substring(2);
        return Qt.rgba(parseInt(hex.substring(0, 2), 16) / 255,
                       parseInt(hex.substring(2, 4), 16) / 255,
                       parseInt(hex.substring(4, 6), 16) / 255, alpha);
    }
}
