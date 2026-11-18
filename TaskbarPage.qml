import QtQuick

Rectangle {
    id: page
    required property var settings
    required property var theme
    color: page.theme.surface

    Row {
        x: 20
        y: 20
        spacing: 12

        Text {
            text: "Rounded corners"
            color: page.theme.text
            height: 24
            verticalAlignment: Text.AlignVCenter
        }

        ToggleSwitch {
            checked: page.settings.taskbarRounded
            onToggled: page.settings.taskbarRounded = !page.settings.taskbarRounded
        }
    }
}