import QtQuick
Item {
    property bool blocked: false
    signal closeRequested()
    signal deleteRequested()
    signal moveRequested(int dx, int dy)
    signal returnRequested()
    signal activateRequested()
    signal tabRequested(int direction)
    signal textKey(string text, int modifiers)
    focus: true
    Keys.onPressed: function(event) {
        if (blocked) return;
        event.accepted = true;
        switch (event.key) {
        case Qt.Key_Escape: closeRequested(); break;
        case Qt.Key_Delete: case Qt.Key_Backspace: deleteRequested(); break;
        case Qt.Key_Left: moveRequested(-1, 0); break;
        case Qt.Key_Right: moveRequested(1, 0); break;
        case Qt.Key_Up: moveRequested(0, -1); break;
        case Qt.Key_Down: moveRequested(0, 1); break;
        case Qt.Key_Return: case Qt.Key_Enter: returnRequested(); activateRequested(); break;
        case Qt.Key_Space: activateRequested(); break;
        case Qt.Key_Tab: tabRequested(1); break;
        case Qt.Key_Backtab: tabRequested(-1); break;
        default: if (event.text) textKey(event.text, event.modifiers); else event.accepted = false;
        }
    }
}
