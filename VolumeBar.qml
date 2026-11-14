import QtQuick

Rectangle {
    id: bar
    width: 40
    height: 200
    color: "#222222"
    radius: 10

    required property real volume
    required property bool muted
    
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left

        height: parent.height * volume

        radius: 10
        color: bar.muted ? "#888888" : "#ffffff"

    }
}
