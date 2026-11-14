import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic


ApplicationWindow {
    id: window
    width: 900
    height: 720
    minimumWidth: 680
    minimumHeight: 560
    visible: true
    title: "Test 1"

    property date now: new Date()

    property int activeWorkspace

    Timer {
        id: timer
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            window.now = new Date()
        }
    }

    BarContent {
        timenow: window.now
        width: parent.width


        activeWorkspace: window.activeWorkspace
        onWorkspaceClicked: (number) => window.activeWorkspace = number

        mediaText: "Test Song — Artist"
        mediaPlaying: true
    }


}
