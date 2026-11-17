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

    property int activeWorkspace: 1

    Timer {
        id: timer
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            window.now = new Date()
        }
    }

    Settings {
        id: settings
    }

    Theme {
        id: theme
        dark: settings.darkTheme
    }

    BarContent {
        timenow: window.now
        width: parent.width

        volume: 0.5
        muted: false

        rounded: settings.statusbarRounded


        activeWorkspace: window.activeWorkspace
        onWorkspaceClicked: (number) => window.activeWorkspace = number

        mediaText: "Test Song — Artist"
        mediaPlaying: true
    }


    ListModel {
        id: windowsModel
        ListElement { title: "Firefox"; appId: "firefox"; active: true }
        ListElement { title: "Terminal"; appId: "fish"; active: false }
        ListElement { title: "Spotify"; appId: "spotify"; active: false }
        ListElement { title: "Claude"; appId: "claude"; active: false }
    }

    Taskbar {
        windows: windowsModel
        isCircled: settings.taskbarRounded

        anchors.bottom: parent.bottom
        width: parent.width


        onWindowClicked: (index) => {
            for (let i = 0; i < windowsModel.count; i++) {
                windowsModel.setProperty(i, "active", i === index)
            }
        }
    }


    SettingsPanel {
        anchors.centerIn: parent
        settings: settings
        theme: theme
    }

}
