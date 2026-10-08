pragma Singleton
import QtQuick
QtObject {
    function clamp(n, low, high) { return Math.max(low, Math.min(high, n)) }
    function alpha(c, a) { return Qt.rgba(c.r, c.g, c.b, a) }
}
