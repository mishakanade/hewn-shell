import Quickshell
import QtQuick

import Quickshell.Services.Pipewire

import Quickshell.Hyprland

import Quickshell.Services.Mpris

import Quickshell.Io

import Quickshell.Wayland

ShellRoot {
    id: root

    readonly property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

    SystemClock {
        id: clock
    }

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }

    property bool osdVisible: false

    Connections {
        target: Pipewire.defaultAudioSink?.audio

        function onVolumeChanged() {
            root.osdVisible = true
            osdTimer.restart()
        }

        function onMutedChanged() {
            root.osdVisible = true
            osdTimer.restart()
        }
    }

    Timer {
        id: osdTimer
        interval: 1500
        onTriggered: root.osdVisible = false
    }

    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 40

        BarContent {
            anchors.fill: parent
            timenow: clock.date                      // откуда брать время?
            activeWorkspace: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id: 1      // откуда брать номер стола?
            onWorkspaceClicked: (number) => Hyprland.dispatch("hl.dsp.focus({ workspace = " + number + " })")  // что сделать при клике?


            volume: Pipewire.defaultAudioSink?.audio?.volume ?? 0
            muted: Pipewire.defaultAudioSink?.audio?.muted ?? false


            onMuteClicked: {
                const audio = Pipewire.defaultAudioSink?.audio
                    if (audio) {
                        audio.muted = !audio.muted
                    }
            }
            onVolumeScrolled: (delta) =>  {
                                  const audio = Pipewire.defaultAudioSink?.audio
                                      if (audio) {
                                          const step = delta > 0 ? 0.05 : -0.05
                                          audio.volume = Math.max(0, Math.min(1, audio.volume + step))
                                      }
                                }

            mediaText: root.player ? root.player.trackTitle + " — " + root.player.trackArtist : ""
            mediaPlaying: root.player ? root.player.isPlaying : false
            onMediaClicked: {
                const p = root.player
                if (p) {
                    p.togglePlaying()
                }
            }
        }
    }

    PanelWindow {
        anchors {
            right: true
        }
        implicitWidth: 40
        implicitHeight: 200
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        visible: root.osdVisible || slideAnim.running

        VolumeBar {
            width: parent.width
            height: parent.height
            x: root.osdVisible ? 0 : parent.width

            Behavior on x {
                NumberAnimation {
                    id: slideAnim
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            volume: Pipewire.defaultAudioSink?.audio?.volume ?? 0
            muted: Pipewire.defaultAudioSink?.audio?.muted ?? false
        }
    }

    PanelWindow {
        anchors {
            left: true
            right: true
            bottom: true
        }
        implicitHeight: 40
        color: "black"

        Row {
            x: 10
            spacing: 12
            anchors.verticalCenter: parent.verticalCenter

            Repeater {
                model: ToplevelManager.toplevels

                Rectangle {
                    id: button
                    required property var modelData
                    width: 160
                    height: 28
                    radius: 8
                    color: button.modelData.activated ? "#f5f5f5" : "#808080"

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        verticalAlignment: Text.AlignVCenter
                        text: button.modelData.title
                        elide: Text.ElideRight
                        color: button.modelData.activated ? "black" : "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: button.modelData.activate()
                    }
                }
            }
        }
    }

    Settings { id: appSettings }

    Theme {
        id: appTheme
        dark: appSettings.darkTheme
    }

    property bool settingsOpen: false

    LazyLoader {
        active: root.settingsOpen

        FloatingWindow {
            title: "Hewn Settings"
            color: appTheme.bg
            implicitWidth: 700
            implicitHeight: 450
            onClosed: root.settingsOpen = false

            SettingsPanel {
                anchors.fill: parent
                settings: appSettings
                theme: appTheme
            }
        }
    }

    IpcHandler {
        target: "settings"

        function toggle(): void {
            root.settingsOpen = !root.settingsOpen
        }
    }
}