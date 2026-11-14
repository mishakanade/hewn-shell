import Quickshell
import QtQuick

import Quickshell.Services.Pipewire

import Quickshell.Hyprland

ShellRoot {
    id: root

    SystemClock {
        id: clock
    }

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
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
        }
    }
}