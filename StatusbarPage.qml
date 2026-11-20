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
                text: "Style"
                width: 160
                color: page.theme.text
                height: 32
                verticalAlignment: Text.AlignVCenter
            }

            ComboBox {
                width: 160
                model: [
                    { text: "Islands", value: "islands" },
                    { text: "Solid bar", value: "bar" }
                ]
                textRole: "text"
                valueRole: "value"
                currentIndex: indexOfValue(page.settings.statusbarStyle)
                onActivated: page.settings.statusbarStyle = currentValue
            }
        }

        // имеет смысл только для островов
        Row {
            spacing: 12
            visible: page.settings.statusbarStyle === "islands"

            Text {
                text: "Rounded islands"
                width: 160
                color: page.theme.text
                height: 24
                verticalAlignment: Text.AlignVCenter
            }

            ToggleSwitch {
                checked: page.settings.statusbarRounded
                onToggled: page.settings.statusbarRounded = !page.settings.statusbarRounded
            }
        }
    }
}