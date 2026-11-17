import QtQuick

QtObject {
    required property bool dark

    readonly property color bg: dark ? "#111111" : "#f2f2f2"
    readonly property color surface: dark ? "#222222" : "#ffffff"
    readonly property color text: dark ? "#ffffff" : "#111111"
    readonly property color accent: "#4caf50"
}