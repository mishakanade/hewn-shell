import QtQuick
import QtQuick.Controls.Basic

Rectangle {
    id: taskbar

    required property bool isCircled

    radius: isCircled ? 15 : 0


    height: 40
    color: "#000000"


    required property var windows

    signal windowClicked(int index)


    Row {
        spacing: 17
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10

        Repeater{
            model: taskbar.windows

            delegate: Rectangle {
                required property int index
                required property string title
                required property bool active

                width: 140
                height: 28
                radius: 7
                color: active ? "#f5f5f5" : "#808080"

                Text {
                    anchors.centerIn: parent
                    width: parent.width - 16
                    text: title
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: taskbar.windowClicked(index)
                }
            }
        }
    }
}
