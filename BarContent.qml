import QtQuick
import QtQuick.Controls.Basic


Rectangle {
    id: clockcard
    color: "#000000"
    implicitHeight: 40
    required property date timenow
    radius: 4

    required property int activeWorkspace

    signal workspaceClicked(int number)

    signal muteClicked()
    signal volumeScrolled(int delta)



    required property real volume
    required property bool muted

    signal mediaClicked()


    required property string mediaText
    required property bool mediaPlaying



    Row {
        spacing: 10
        padding: 5

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: 4

            delegate: Rectangle {
                required property int index
                readonly property int number: index + 1

                width: 30
                height: 25
                radius: 7
                color: clockcard.activeWorkspace === number
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
                    onClicked: clockcard.workspaceClicked(number)
                }
            }

        }

    }

    Text {
        id: clocktext
        anchors.centerIn: parent

        color: "#ffffff"
        text: Qt.formatDateTime(clockcard.timenow, "h:mm:ss")
    }

    Text {
        anchors.right: datetext.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 30

        color: "#ffffff"
        text: clockcard.muted ? "mute": Math.round(clockcard.volume * 100) + "%"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                clockcard.muteClicked()
            }
            onWheel: (wheel) => clockcard.volumeScrolled(wheel.angleDelta.y)
        }

    }

    Text {
        id: datetext
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 10



        color: "#ffffff"

        text: Qt.formatDate(clockcard.timenow, "dd.MM.yyyy")
    }

    Text {
        anchors.right: clocktext.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 30

        color: "#ffffff"
        text: clockcard.mediaText
        visible: clockcard.mediaText !== ""
        elide: Text.ElideRight
        width: Math.min(implicitWidth, 300)

        MouseArea {
            anchors.fill: parent
            onClicked: clockcard.mediaClicked()
        }
    }
}
