import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts


Rectangle {
    id: panel
    width: 700
    height: 450
    radius: 12
    color: "#111111"

    property int currentTab: 0

    ListModel {
        id: tabsModel
        ListElement { title: "About System" }
        ListElement { title: "Theme" }
        ListElement { title: "Statusbar" }
        ListElement { title: "Taskbar" }
    }


    Column {
        id: sidebar
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 10
        width: 160
        spacing: 6


        Repeater {
            model: tabsModel

            delegate: Rectangle {
                required property string title
                required property int index

                width: sidebar.width
                height: 36
                radius: 8
                color: panel.currentTab === index
                       ? Qt.lighter(panel.color, 3.0)
                       : Qt.lighter(panel.color, 1.8)

                Text {
                    anchors.centerIn: parent
                    text: title
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: panel.currentTab = index
                }
            }
        }
    }

    StackLayout {
        anchors.left: sidebar.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 10

        currentIndex: panel.currentTab

        Rectangle { color: "#222222"; Text { anchors.centerIn: parent; color: "white"; text: "About System" } }
        ThemePage { }
        Rectangle { color: "#222222"; Text { anchors.centerIn: parent; color: "white"; text: "Statusbar" } }
        Rectangle { color: "#222222"; Text { anchors.centerIn: parent; color: "white"; text: "Taskbar" } }
    }
}
