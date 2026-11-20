import QtQuick

Rectangle {
    id: button
    property string title: ""
    property bool active: false
    signal clicked()

    width: 160
    height: 28
    radius: 8
    color: button.active ? "#f5f5f5" : "#808080"

    Text {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        verticalAlignment: Text.AlignVCenter
        text: button.title
        elide: Text.ElideRight
        color: button.active ? "black" : "white"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: button.clicked()
    }
}