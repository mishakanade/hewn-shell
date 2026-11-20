import QtQuick
import QtQuick.Controls.Basic

ComboBox {
    id: control
    required property var theme

    implicitWidth: 160
    implicitHeight: 32

    // значение настройки (приходит снаружи) и сигнал выбора пользователем
    property var value
    signal valueSelected(var newValue)

    function syncIndex() {
        currentIndex = indexOfValue(value)
    }

    onValueChanged: syncIndex()
    Component.onCompleted: syncIndex()
    onActivated: control.valueSelected(currentValue)

    // сам «закрытый» список
    background: Rectangle {
        radius: 8
        color: control.theme.bg
        border.width: 1
        border.color: control.popup.visible || control.hovered ? control.theme.accent : "transparent"
    }

    // выбранное значение
    contentItem: Text {
        leftPadding: 12
        rightPadding: 32
        text: control.displayText
        color: control.theme.text
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // стрелка: переворачивается, когда меню открыто
    indicator: Text {
        x: control.width - width - 12
        y: (control.height - height) / 2
        text: "▾"
        color: control.theme.text
        rotation: control.popup.visible ? 180 : 0
        Behavior on rotation { NumberAnimation { duration: 120 } }
    }

    // пункт меню
    delegate: ItemDelegate {
        id: option
        required property var model
        required property int index

        width: control.width - 8
        height: 30
        highlighted: control.highlightedIndex === index

        contentItem: Text {
            leftPadding: 8
            text: option.model[control.textRole]
            color: control.theme.text
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            radius: 6
            color: option.highlighted ? control.theme.surface : "transparent"
        }
    }

    // выпадающее меню
    popup: Popup {
        y: control.height + 4
        width: control.width
        implicitHeight: contentItem.implicitHeight + 8
        padding: 4

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
        }

        background: Rectangle {
            radius: 10
            color: control.theme.bg
            border.width: 1
            border.color: "#808080"
        }
    }
}