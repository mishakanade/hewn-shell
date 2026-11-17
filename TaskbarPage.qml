import QtQuick

Rectangle {
    id: page
    required property var settings
    color: "#222222"

    Row {
        x: 20
        y: 20
        spacing: 12

        Text {
            text: "Rounded corners"
            color: "white"
            height: 24
            verticalAlignment: Text.AlignVCenter
        }

        ToggleSwitch {
            checked: page.settings.taskbarRounded
            onToggled: page.settings.taskbarRounded = !page.settings.taskbarRounded
        }
    }
}