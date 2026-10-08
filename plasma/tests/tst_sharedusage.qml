import QtQuick
import QtTest
import "../package/contents/ui"
import "../package/contents/ui/Io"

TestCase {
    name: "SharedUsage"
    when: windowShown
    width: 388
    height: 380
    visible: true
    Component {
        id: viewFactory
        UsagePanel {
            pollingEnabled: false
            usageSource: UsageSource
            report: UsageSource.report
            errorMessage: UsageSource.errorMessage
            pluginStale: UsageSource.pluginStale
            loading: UsageSource.loading
            notInstalled: UsageSource.notInstalled
        }
    }
    SignalSpy { id: reports; target: UsageSource; signalName: "reportChanged" }
    function cleanup() { UsageSource.clients = [] }
    function test_twoPanelsShareFetches() {
        UsageSource.program = Native.localFile(Qt.resolvedUrl("mock-shared-cli.sh"))
        UsageSource.fallbackProgram = ""
        var first = createTemporaryObject(viewFactory, this, {settings: {showRemaining: true}})
        verify(first !== null)
        reports.clear()
        UsageSource.registerClient(first, 300)
        tryVerify(function() { return UsageSource.report !== null && !UsageSource.fetchBusy }, 5000)
        compare(reports.count, 1)
        compare(first.barLabel, "54%")

        // Joining an existing cycle must not start another CLI invocation.
        var second = createTemporaryObject(viewFactory, this, {settings: {showRemaining: true, barWindow: "Weekly"}})
        verify(second !== null)
        UsageSource.registerClient(second, 300)
        wait(350)
        compare(reports.count, 1)
        compare(first.report, second.report)
        compare(second.barLabel, "53%")
        compare(UsageSource.clientCount, 2)

        // Simultaneous manual requests share the in-flight refresh, too.
        first.refresh(true)
        second.refresh(true)
        verify(first.fetchBusy && second.fetchBusy)
        tryVerify(function() { return !UsageSource.fetchBusy }, 5000)
        compare(reports.count, 2)
        compare(first.report, second.report)

        UsageSource.registerClient(first, 600)
        compare(UsageSource.refreshIntervalSec, 300)
        UsageSource.unregisterClient(second)
        compare(UsageSource.refreshIntervalSec, 600)

        // A shared operational failure retains the good data in every view.
        var lastReport = first.report
        UsageSource.program = "/usr/bin/true"
        first.refresh(true)
        tryVerify(function() { return UsageSource.errorMessage !== "" && !UsageSource.fetchBusy }, 5000)
        compare(first.report, lastReport)
        compare(second.report, lastReport)
        verify(first.pluginStale && second.pluginStale)
        verify(!UsageSource.notInstalled)

        UsageSource.unregisterClient(first)
        compare(UsageSource.clientCount, 0)
        verify(!UsageSource.backend.pollingEnabled)
    }
}
