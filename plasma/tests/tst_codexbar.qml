import QtQuick
import QtTest
import "../package/contents/ui"
import "../package/contents/ui/Io"
import "../package/contents/ui/Commons" as Compat
TestCase {
    name: "CodexBarPlasma"
    when: windowShown
    width: 388
    height: 580
    visible: true
    Item {
        id: fixture
        width: 388
        height: 580
        Rectangle { anchors.fill: parent; color: Compat.Color.background }
        UsagePanel { id: panel; anchors.fill: parent; pollingEnabled: false; opened: true }
    }
    FileView { id: sample; path: Native.localFile(Qt.resolvedUrl("report.json")) }
    Component { id: panelComponent; UsagePanel { pollingEnabled: false; width: 388; height: 580 } }

    function init() {
        panel.settings = ({showRemaining: false})
        panel.exitCode = 0
        panel.handle(sample.text())
    }
    function test_themeHelpers() {
        verify(Compat.Color.popups !== undefined)
        verify(Compat.Color.popups.background.a > 0)
        verify(Compat.Color.popups.text.a > 0)
        compare(panel.foreground, Compat.Color.popups.text)
    }
    function test_displayAndSettings() {
        compare(panel.usageWindows.length, 3)
        compare(panel.barLabel, "46%")
        verify(panel.hasCredits)
        var gauge = panel.usageColor(46)
        verify(isFinite(gauge.r) && isFinite(gauge.g) && isFinite(gauge.b))
        verify(gauge.a > 0)
        panel.settings = ({barWindow: "Worst", showRemaining: false})
        compare(panel.barLabel, "47%")
        panel.settings = ({showRemaining: true})
        compare(panel.barLabel, "54%")
        compare(panel.barWindowPct, 46)
        compare(Number(panel.usageWindows[0].used_pct), 46)
        panel.settings = ({showRemaining: true, barWindow: "Worst"})
        compare(panel.barLabel, "53%")
        panel.settings = ({showLabel: false})
        compare(panel.barLabel, "")
        panel.settings = ({colorMode: "none"})
        verify(!panel.barColored && !panel.panelColored)
        panel.settings = ({})
        wait(500)
        fixture.grabToImage(function(result) { result.saveToFile(Native.localFile(Qt.resolvedUrl("../test-preview.png"))) })
        wait(100)
    }
    function test_failureRetainsReport() {
        var lastReport = panel.report
        panel.handle("invalid JSON")
        compare(panel.report, lastReport)
        verify(panel.pluginStale)
        verify(panel.errorMessage !== "")
        panel.handle('{"schema_version":1}')
        verify(panel.errorMessage.indexOf("schema_version 2") >= 0)
        panel.handle(sample.text())
        verify(!panel.pluginStale)
        compare(panel.errorMessage, "")
    }
    function test_smallPopupScrolls() {
        fixture.width = 260
        fixture.height = 220
        var flick = findChild(panel, "panelFlick")
        verify(flick !== null)
        tryCompare(flick, "width", 236)
        compare(flick.height, 196)
        compare(panel.implicitHeight, flick.contentHeight + 24)
        verify(flick.clip)
        verify(flick.interactive)
        verify(flick.contentHeight > flick.height)
        flick.contentY = flick.contentHeight - flick.height
        verify(flick.contentY > 0)
        compare(panel.usageWindows.length, 3)
        fixture.height = Math.ceil(panel.implicitHeight)
        tryVerify(function() { return flick.height >= flick.contentHeight })
        verify(!flick.interactive)
        fixture.width = 388
        fixture.height = 580
        flick.contentY = 0
    }
    function test_processFallback() {
        var item = createTemporaryObject(panelComponent, fixture, {
            binName: "/missing/codexbar-for-test",
            bundledCmd: Native.localFile(Qt.resolvedUrl("mock-cli.sh"))
        })
        verify(item !== null)
        item.refresh(false)
        tryVerify(function() { return item.report !== null && !item.fetchBusy }, 5000)
        compare(item.resolvedBin, item.bundledCmd)
        verify(!item.notInstalled)
        compare(item.usageWindows.length, 3)
    }
    function test_emptyExitIsOperationalFailure() {
        var item = createTemporaryObject(panelComponent, fixture, {
            binName: "/usr/bin/true",
            bundledCmd: Native.localFile(Qt.resolvedUrl("mock-cli.sh"))
        })
        item.refresh(false)
        tryVerify(function() { return item.errorMessage !== "" && !item.fetchBusy }, 5000)
        verify(item.errorMessage.indexOf("produced no output") >= 0)
        verify(!item.notInstalled)
        compare(item.resolvedBin, "/usr/bin/true")
    }
}
