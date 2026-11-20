import QtQuick

Rectangle {
    id: page
    required property var settings
    required property var theme
    color: page.theme.surface

    Column {
        x: 20
        y: 20
        spacing: 12

        Row {
            spacing: 12

            Text {
                text: "Rounded corners"
                width: 160
                color: page.theme.text
                height: 24
                verticalAlignment: Text.AlignVCenter
            }

            ToggleSwitch {
                checked: page.settings.taskbarRounded
                onToggled: page.settings.taskbarRounded = !page.settings.taskbarRounded
            }
        }

        Row {
            spacing: 12

            Text {
                text: "Show window titles"
                width: 160
                color: page.theme.text
                height: 24
                verticalAlignment: Text.AlignVCenter
            }

            ToggleSwitch {
                checked: page.settings.taskbarTextVisible
                onToggled: page.settings.taskbarTextVisible = !page.settings.taskbarTextVisible
            }
        }
    }
}