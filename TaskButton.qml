import QtQuick

Item {
    id: button
    property string title: ""
    property string icon: ""
    property bool active: false
    property bool showText: true
    signal clicked()

    width: button.showText ? 160 : 36
    height: button.showText ? 28 : 36

    // фон только в режиме с текстом
    Rectangle {
        anchors.fill: parent
        visible: button.showText
        radius: 8
        color: button.active ? "#f5f5f5" : "#808080"
    }

    Image {
        id: iconImage
        source: button.icon
        width: 22
        height: 22
        x: button.showText ? 8 : (button.width - width) / 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: button.showText ? 0 : -3
        fillMode: Image.PreserveAspectFit
        visible: button.icon !== ""
    }

    // название окна (режим с текстом)
    Text {
        visible: button.showText
        anchors.fill: parent
        anchors.leftMargin: iconImage.visible ? 36 : 8
        anchors.rightMargin: 8
        verticalAlignment: Text.AlignVCenter
        text: button.title
        elide: Text.ElideRight
        color: button.active ? "black" : "white"
    }

    // первая буква, если иконки нет (режим без текста)
    Text {
        visible: !button.showText && button.icon === ""
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -3
        text: button.title.charAt(0).toUpperCase()
        color: "white"
        font.pixelSize: 16
    }

    // точка под активным окном (режим без текста)
    Rectangle {
        visible: !button.showText && button.active
        width: 6
        height: 6
        radius: 3
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
    }

    MouseArea {
        anchors.fill: parent
        onClicked: button.clicked()
    }
}