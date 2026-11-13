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



    required property real volume
    required property bool muted


    Row {
        spacing: 10
        padding: 5

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: 4

            delegate: Button {
                required property int index
                readonly property int number: index + 1

                width: 30
                height: 25

                text: number
                highlighted: clockcard.activeWorkspace == number
                onClicked: clockcard.workspaceClicked(number)

            }

        }

    }

    Text {
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

    }

    Text {
        id: datetext
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 10



        color: "#ffffff"

        text: Qt.formatDate(clockcard.timenow, "dd.MM.yyyy")
    }
}
