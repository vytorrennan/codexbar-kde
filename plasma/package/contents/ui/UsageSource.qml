pragma Singleton
import QtQuick
import "Io"

QtObject {
    id: source
    property var clients: []
    property string program: "codexbar"
    property string fallbackProgram: Native.localFile(Qt.resolvedUrl("../code/codexbar"))
    readonly property int clientCount: clients.length
    readonly property int refreshIntervalSec: {
        var interval = 3600
        for (var i = 0; i < clients.length; i++)
            interval = Math.min(interval, clients[i].interval)
        return clients.length ? interval : 300
    }
    readonly property var report: backend.report
    readonly property string errorMessage: backend.errorMessage
    readonly property bool pluginStale: backend.pluginStale
    readonly property bool loading: backend.loading
    readonly property bool notInstalled: backend.notInstalled
    readonly property bool fetchBusy: backend.fetchBusy

    function registerClient(client, interval) {
        var next = clients.filter(function(entry) { return entry.client !== client })
        next.push({client: client, interval: Math.max(15, Number(interval) || 300)})
        clients = next
    }
    function unregisterClient(client) {
        clients = clients.filter(function(entry) { return entry.client !== client })
    }
    function refresh(force) {
        // Requests arriving during a shared fetch join it instead of queueing
        // another forced API request.
        if (!backend.fetchBusy) backend.refresh(force === true)
    }

    // Keep the existing CLI fallback, validation and stale-report handling in
    // one place. This hidden instance owns the only polling timer.
    readonly property UsagePanel backend: UsagePanel {
        visible: false
        coalesceRefreshes: true
        pollingEnabled: source.clientCount > 0
        binName: source.program
        bundledCmd: source.fallbackProgram
        settings: ({refreshIntervalSec: source.refreshIntervalSec})
    }
}
