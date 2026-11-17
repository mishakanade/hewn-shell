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
        padding: 10


        Repeater{
            model: taskbar.windows

            delegate: Button {
                required property int index
                required property string title
                required property bool active

                text: title
                highlighted: active

                onClicked: {
                    windowClicked(index)
                }
            }
        }
    }
}
