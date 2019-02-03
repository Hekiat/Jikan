import QtQuick 2.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.12

Rectangle {
    id: delegateItem

    property var noteObj: null

    width: parent.width;
    height: childrenRect.height

    color: index % 2 == 0 ? "#474747" : "#3a3a3a"

    Rectangle {
        id: noteHeader

        width: parent.width
        height: 30

        color: "#2196F3" // Material.accent: "#2196F3"

        Text {
            id: noteDate

            width: parent.width
            height: parent.height / 2

            font.pointSize: 12
            font.bold: true
            color: "white"

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            text: noteObj.date.toLocaleDateString(Qt.locale(), Locale.ShortFormat) + noteObj.date.toLocaleDateString(Qt.locale(), " (ddd)")
        }

        Text {
            id: noteDuration

            width: parent.width
            height: parent.height / 2

            anchors.top: noteDate.bottom
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            //anchors.rightMargin: 20

            color: "white"
            font.pointSize: 10

            text: noteObj.duration + (noteObj.duration < 1.0 ? " hour" : " hour(s)")
            font.italic: true
        }

        ToolButton {
            id: deleteNote

            width: parent.height
            height: width

            anchors.right: parent.right

            icon.source: "qrc:/close.png"
            onClicked: noteObj.remove()
        }


        ToolButton {
            id: collapseNoteBtn

            width: parent.height
            height: width

            anchors.right: deleteNote.left

            checkable: true

            icon.source: noteObj.collapsed ? "qrc:/arrow_up.png" : "qrc:/arrow_down.png"

            onClicked: noteObj.collapsed = checked

            Component.onCompleted: checked = noteObj.collapsed
        }
    }

    Item {
        anchors.top: noteHeader.bottom
        anchors.topMargin: collapseNoteBtn.checked ? 0 : 10

        visible: !collapseNoteBtn.checked

        width: parent.width
        height: collapseNoteBtn.checked ? 0 : childrenRect.height

        TextEdit {
            id: noteContent

            width: parent.width

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10

            readOnly: true
            selectByMouse: true

            color: "white"
            font.pointSize: 12

            text: noteObj.content
        }

        Rectangle { // Spacer
            id: bottomSpacer
            anchors.top: noteContent.bottom
            width: parent.width
            height: 10
            opacity: 0
        }

        Rectangle{
            id: tagBarItem

            height: 30
            width: parent.width

            anchors.top: bottomSpacer.bottom
            color: "#4f4f4f"

            Rectangle {
                height: 1
                width: parent.width
                color: "#1777c4"
            }

            RowLayout {
                anchors.fill: parent

                Label {
                    id: tagLabel

                    leftPadding: 10
                    //padding: 10

                    text: "Tags:"

                    font.pixelSize: 16
                    font.bold: true
                    verticalAlignment: Text.AlignVCenter
                }

                Rectangle {
                    width: tagsView.height - 7
                    height: width
                    radius: 3
                    color: "#2196F3"
                    Layout.alignment: Qt.AlignVCenter

                    Image {
                        id: name
                        anchors.fill: parent
                        source: "qrc:/add.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: {
                            if (mouse.button === Qt.RightButton || mouse.button === Qt.LeftButton) {
                                contextMenu.x = mouse.x;
                                contextMenu.y = mouse.y;

                                contextMenu.open();
                            }
                        }
                    }

                    Menu {
                        id: contextMenu

                        Repeater {
                            model: tagModel

                            MenuItem {
                                height: 30
                                text: modelData.name

                                Rectangle {
                                    id: itemTagColor

                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    color: modelData.color

                                    width: 10
                                    height: parent.height
                                }

                                onTriggered: noteObj.addTag(modelData)
                            }
                        }
                    }
                }

                ListView {
                    id: tagsView

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    height: parent.height - 1

                    spacing: 4
                    orientation: ListView.Horizontal
                    clip: true

                    model: noteObj.tags

                    delegate: Rectangle {
                        width: tagTextLbl.width + 4
                        height: tagsView.height - 8
                        radius: 3

                        anchors.verticalCenter: parent.verticalCenter

                        color: modelData.color

                        Label {
                            id: tagTextLbl
                            verticalAlignment: Text.AlignVCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.name
                            font.pixelSize: 14
                        }
                    }
                }
            }
        }
    }
}
