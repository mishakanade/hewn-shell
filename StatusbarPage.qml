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
                width: 190
                color: page.theme.text
                height: 32
                verticalAlignment: Text.AlignVCenter
            }

            ThemedComboBox {
                theme: page.theme
                model: [
                    { text: "Islands", value: "islands" },
                    { text: "Solid bar", value: "bar" }
                ]
                textRole: "text"
                valueRole: "value"
                value: page.settings.statusbarStyle
                onValueSelected: (v) => page.settings.statusbarStyle = v
            }
        }

        // имеет смысл только для островов
        Row {
            spacing: 12
            visible: page.settings.statusbarStyle === "islands"

            Text {
                text: "Rounded islands"
                width: 190
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