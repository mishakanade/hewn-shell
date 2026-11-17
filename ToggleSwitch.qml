import QtQuick

Rectangle {
    id: sw
    property bool checked: false
    signal toggled()

    width: 44
    height: 24
    radius: 12
    color: sw.checked ? "#4caf50" : "#808080"

    Rectangle {
        width: 20
        height: 20
        radius: 10
        color: "white"
        y: 2
        x: sw.checked ? parent.width - width - 2 : 2
        Behavior on x { NumberAnimation { duration: 120 } }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: sw.toggled()
    }
}