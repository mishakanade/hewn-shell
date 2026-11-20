import QtQuick
import QtQuick.Controls.Basic

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

        Row {
            spacing: 12

            Text {
                text: "Icons position"
                width: 160
                color: page.theme.text
                height: 32
                verticalAlignment: Text.AlignVCenter
            }

            ComboBox {
                width: 160
                model: [
                    { text: "Left", value: "left" },
                    { text: "Center", value: "center" },
                    { text: "Right", value: "right" }
                ]
                textRole: "text"
                valueRole: "value"
                currentIndex: indexOfValue(page.settings.taskbarAlign)
                onActivated: page.settings.taskbarAlign = currentValue
            }
        }

        Row {
            spacing: 12

            Text {
                text: "Transparent background"
                width: 160
                color: page.theme.text
                height: 24
                verticalAlignment: Text.AlignVCenter
            }

            ToggleSwitch {
                checked: page.settings.taskbarTransparent
                onToggled: page.settings.taskbarTransparent = !page.settings.taskbarTransparent
            }
        }

        Row {
            spacing: 12

            Text {
                text: "Window preview"
                width: 160
                color: page.theme.text
                height: 32
                verticalAlignment: Text.AlignVCenter
            }

            ComboBox {
                width: 160
                model: [
                    { text: "Off", value: "off" },
                    { text: "Only text", value: "title" },
                    { text: "Text + preview", value: "preview" }
                ]
                textRole: "text"
                valueRole: "value"
                currentIndex: indexOfValue(page.settings.taskbarTooltip)
                onActivated: page.settings.taskbarTooltip = currentValue
            }
        }
    }
}