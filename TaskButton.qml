import QtQuick

Rectangle {
    id: button
    property string title: ""
    property bool active: false

    property string icon: ""

    signal clicked()

    width: 160
    height: 28
    radius: 8
    color: button.active ? "#f5f5f5" : "#808080"

    Image {
        id: iconImage
        source: button.icon
        width: 20
        height: 20
        x: 8
        anchors.verticalCenter: parent.verticalCenter
        visible: button.icon !== ""
        fillMode: Image.PreserveAspectFit
    }

    Text {
        anchors.fill: parent
        anchors.leftMargin: iconImage.visible ? 36 : 8
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