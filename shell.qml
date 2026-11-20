import Quickshell
import QtQuick

import Quickshell.Services.Pipewire

import Quickshell.Hyprland

import Quickshell.Services.Mpris

import Quickshell.Io

import Quickshell.Wayland

ShellRoot {
    id: root

    // Какой плеер считать активным: Spotify, если играет; иначе любой играющий;
    // иначе Spotify (если запущен); иначе первый в списке
    property var activePlayer: {
        const players = Mpris.players.values
        let spotify = null
        let playing = null
        for (const p of players) {
            if (p.desktopEntry === "spotify" || p.identity === "Spotify") spotify = p
            if (p.isPlaying && !playing) playing = p
        }
        if (spotify && spotify.isPlaying) return spotify
        if (playing) return playing
        return spotify ?? players[0] ?? null
    }

    readonly property var player: root.activePlayer

    SystemClock {
        id: clock
    }

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }

    property bool osdVisible: false

    Connections {
        target: Pipewire.defaultAudioSink?.audio ?? null

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

    // ===== Верхняя панель (статусбар) =====
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 40

        BarContent {
            anchors.fill: parent
            rounded: appSettings.statusbarRounded
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
            onVolumeScrolled: (delta) => {
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

    // ===== OSD громкости (справа) =====
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

    // ===== Таскбар (снизу) =====
    PanelWindow {
        anchors {
            left: true
            right: true
            bottom: true
        }
        implicitHeight: 40
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: "black"
            radius: appSettings.taskbarRounded ? 12 : 0

            Row {
                x: appSettings.taskbarAlign === "center" ? (parent.width - width) / 2
                 : appSettings.taskbarAlign === "right" ? parent.width - width - 10
                 : 10
                spacing: 12
                anchors.verticalCenter: parent.verticalCenter

                Behavior on x {
                                    NumberAnimation {
                                        duration: 200
                                        easing.type: Easing.OutCubic
                                    }
                                }

                // основные окна
                Repeater {
                    model: Hyprland.toplevels

                    TaskButton {
                        required property var modelData
                        visible: !(modelData.workspace?.name ?? "").startsWith("special:")
                        title: modelData.title
                        active: modelData.activated
                        showText: appSettings.taskbarTextVisible
                        onClicked: modelData.wayland?.activate()
                        icon: {
                            DesktopEntries.applications.values   // только чтобы привязка пересчитывалась, когда база загрузится
                            return Quickshell.iconPath(DesktopEntries.heuristicLookup(modelData.wayland?.appId ?? "")?.icon ?? "", true)
                        }
                    }
                }

                // разделитель
                Rectangle {
                    width: 2
                    height: 20
                    radius: 1
                    color: "#808080"
                    anchors.verticalCenter: parent.verticalCenter
                }

                // окна из special-воркспейсов
                Repeater {
                    model: Hyprland.toplevels

                    TaskButton {
                        required property var modelData
                        visible: (modelData.workspace?.name ?? "").startsWith("special:")
                        title: modelData.title
                        active: modelData.activated
                        showText: appSettings.taskbarTextVisible
                        onClicked: modelData.wayland?.activate()
                        icon: {
                            DesktopEntries.applications.values   // только чтобы привязка пересчитывалась, когда база загрузится
                            return Quickshell.iconPath(DesktopEntries.heuristicLookup(modelData.wayland?.appId ?? "")?.icon ?? "", true)
                        }
                    }
                }
            }
        }
    }

    // ===== Настройки и тема =====
    Settings { id: appSettings }

    Theme {
        id: appTheme
        dark: appSettings.darkTheme
    }

    // ===== Сохранение настроек в ~/.config/hewn/settings.json =====
    FileView {
        id: settingsFile
        path: Quickshell.env("HOME") + "/.config/hewn/settings.json"

        // файла ещё нет (первый запуск): разрешаем запись
        onLoadFailed: root.settingsReady = true

        onLoaded: {
            try {
                const d = JSON.parse(settingsFile.text())
                if (d.darkTheme !== undefined) appSettings.darkTheme = d.darkTheme
                if (d.statusbarRounded !== undefined) appSettings.statusbarRounded = d.statusbarRounded
                if (d.taskbarRounded !== undefined) appSettings.taskbarRounded = d.taskbarRounded
                if (d.taskbarTextVisible !== undefined) appSettings.taskbarTextVisible = d.taskbarTextVisible
                if (d.taskbarAlign !== undefined) appSettings.taskbarAlign = d.taskbarAlign
            } catch (e) {
                console.log("hewn settings: cannot parse file:", e)
            }
            root.settingsReady = true
        }
    }

    // пишем в файл только после загрузки, чтобы не затереть сохранённое значениями по умолчанию
    property bool settingsReady: false

    readonly property string settingsJson: JSON.stringify({
        darkTheme: appSettings.darkTheme,
        statusbarRounded: appSettings.statusbarRounded,
        taskbarRounded: appSettings.taskbarRounded,
        taskbarTextVisible: appSettings.taskbarTextVisible,
        taskbarAlign: appSettings.taskbarAlign
    })
    onSettingsJsonChanged: if (settingsReady) settingsFile.setText(settingsJson)

    // ===== Окно настроек =====
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