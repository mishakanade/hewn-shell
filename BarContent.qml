import QtQuick
import QtQuick.Controls.Basic

Item {
    id: bar
    implicitHeight: 40

    required property date timenow
    required property int activeWorkspace

    signal workspaceClicked(int number)
    signal muteClicked()
    signal volumeScrolled(int delta)
    signal mediaClicked()

    required property real volume
    required property bool muted
    required property string mediaText
    required property bool mediaPlaying

    property bool rounded: false
    property bool islands: true

    // общие размеры островов
    readonly property int islandHeight: 32
    readonly property int islandRadius: rounded ? islandHeight / 2 : 0
    readonly property color islandColor: bar.islands ? "#000000" : "transparent"
    readonly property int islandPadding: 12
    readonly property int islandGap: 6

    // сплошная полоса (режим без островов)
    // сплошная полоса (режим без островов)
    Rectangle {
        anchors.fill: parent
        visible: !bar.islands
        color: "#000000"
    }

    // ===== Остров 1: воркспейсы =====
    Rectangle {
        id: workspacesIsland
        anchors.left: parent.left
        anchors.leftMargin: bar.islandGap
        anchors.verticalCenter: parent.verticalCenter
        height: bar.islandHeight
        width: workspacesRow.implicitWidth + bar.islandPadding
        radius: bar.islandRadius
        color: bar.islandColor

        Row {
            id: workspacesRow
            anchors.centerIn: parent
            spacing: 6

            Repeater {
                model: 4

                delegate: Rectangle {
                    required property int index
                    readonly property int number: index + 1

                    width: 28
                    height: 24
                    radius: 7
                    color: bar.activeWorkspace === number
                           ? "#f5f5f5"
                           : (hoverArea.containsMouse ? "#a0a0a0" : "#808080")

                    Text {
                        anchors.centerIn: parent
                        text: parent.number
                    }

                    MouseArea {
                        id: hoverArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: bar.workspaceClicked(number)
                    }
                }
            }
        }
    }

    // ===== Остров 2: медиа =====
    Rectangle {
        id: mediaIsland
        anchors.left: workspacesIsland.right
        anchors.leftMargin: bar.islandGap
        anchors.verticalCenter: parent.verticalCenter
        height: bar.islandHeight
        width: mediaLabel.width + bar.islandPadding * 2
        radius: bar.islandRadius
        color: bar.islandColor
        visible: bar.mediaText !== ""

        Text {
            id: mediaLabel
            anchors.centerIn: parent
            width: Math.min(implicitWidth, 260)
            elide: Text.ElideRight
            color: "#ffffff"
            text: bar.mediaText
            opacity: bar.mediaPlaying ? 1.0 : 0.6
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: bar.mediaClicked()
        }
    }

    // ===== Остров 3: часы (по центру) =====
    Rectangle {
        id: clockIsland
        anchors.centerIn: parent
        height: bar.islandHeight
        width: clockMetrics.width + bar.islandPadding * 2
        radius: bar.islandRadius
        color: bar.islandColor

        // ширина по шаблону "00:00:00", чтобы остров не дёргался каждую секунду
        TextMetrics {
            id: clockMetrics
            font: clockText.font
            text: "00:00:00"
        }

        Text {
            id: clockText
            anchors.centerIn: parent
            color: "#ffffff"
            text: Qt.formatDateTime(bar.timenow, "h:mm:ss")
        }
    }

    // ===== Остров 4: громкость и дата (справа) =====
    Rectangle {
        id: statusIsland
        anchors.right: parent.right
        anchors.rightMargin: bar.islandGap
        anchors.verticalCenter: parent.verticalCenter
        height: bar.islandHeight
        width: statusRow.implicitWidth + bar.islandPadding * 2
        radius: bar.islandRadius
        color: bar.islandColor

        Row {
            id: statusRow
            anchors.centerIn: parent
            spacing: 16

            Text {
                width: 40
                horizontalAlignment: Text.AlignRight
                color: "#ffffff"
                text: bar.muted ? "mute" : Math.round(bar.volume * 100) + "%"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: bar.muteClicked()
                    onWheel: (wheel) => bar.volumeScrolled(wheel.angleDelta.y)
                }
            }

            Text {
                color: "#ffffff"
                text: Qt.formatDate(bar.timenow, "dd.MM.yyyy")
            }
        }
    }
}