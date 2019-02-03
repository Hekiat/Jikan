import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.0
import QtQuick.Layouts 1.3

Rectangle{
    id: tagItem

    property var tagObj: null

    width: 300
    height: 50

    color: "#474747"

    Rectangle {
        id: tagColor

        anchors.left: parent.left
        anchors.top: parent.top
        color: tagObj ? tagObj.color : "white"

        width: 10
        height: parent.height
    }

    Label {
        id: contentLbl

        anchors.fill: parent
        text: tagObj ? tagObj.name : ""
        font.pixelSize: 22
        font.italic: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    ToolButton {
        id: deleteBtn

        width: 36
        height: width

        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter

        icon.source: "qrc:/close.png"

        onClicked: tagObj.remove()
    }
/*
    Rectangle {
        id: modifyBtn

        width: 20
        height: width
        radius: width/2

        anchors.right: deleteBtn.left
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter

        color: "white"
        opacity: modifyMA.containsMouse ? 0.10 : 0.03

        MouseArea {
            id: modifyMA
            anchors.fill: parent
            hoverEnabled: true

            onClicked: colorDialog.open()

            ColorDialog {
                id: colorDialog

                title: "Change associated Tag color."
                onAccepted: tagObj.color = colorDialog.color
            }
        }
    }
*/
    PopupButton{
        id: modifyBtn


        buttonIconSource: "qrc:/edit.png"
        anchors.right: deleteBtn.left
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter

        popupWidth: 500
        popupHeight: 200
        buttonSize: 36

        onPopped: {
            loaderItem.pTagName = tagObj ? tagObj.name : ""
            loaderItem.pTagColor = tagObj ? tagObj.color : "white"
        }

        component: Item {
            id: itemWgt

            width: modifyBtn.popupWidth
            height: modifyBtn.popupHeight

            property alias pTagName : tagNameEdit.text
            property alias pTagColor : tagColorEdit.color

            GridLayout {
                columns: 2

                anchors.fill: parent
                anchors.topMargin: 30
                anchors.leftMargin: 20

                Label {
                    text: "Tag Edit:"

                    font.pixelSize: 22
                    font.bold: true

                    Layout.row: 0
                    Layout.column: 0

                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                }

                Label {
                    text: "Name:"

                    Layout.row: 1
                    Layout.column: 0

                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                }

                TextField {
                    id: tagNameEdit

                    placeholderText: qsTr("Tag Name")

                    implicitWidth: 300

                    Layout.row: 1
                    Layout.column: 1

                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                }

                Label {
                    text: "Color:"

                    Layout.row: 2
                    Layout.column: 0

                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                }

                Rectangle {
                    id: tagColorEdit

                    color: "white"

                    width: 300
                    height: 20

                    Layout.row: 2
                    Layout.column: 1

                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                    MouseArea {
                        id: modifyTagColorMA

                        anchors.fill: parent

                        hoverEnabled: true

                        onClicked: {
                            colorDialog.color = tagColorEdit.color;
                            colorDialog.open();
                        }

                        cursorShape: Qt.PointingHandCursor

                        ColorDialog {
                            id: colorDialog

                            title: "Change associated Tag color."
                            onAccepted: tagColorEdit.color = colorDialog.color
                        }
                    }
                }

                Item {
                    width: 300
                    height: 300

                    Layout.row: 3
                    Layout.column: 1

                    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                    Row{
                        anchors.right: parent.right
                        spacing: 20

                        Button {
                            text: "Cancel"
                            onClicked: modifyBtn.closePopup()
                        }

                        Button {
                            text: "OK"
                            onClicked: {
                                tagObj.name = tagNameEdit.text;
                                tagObj.color = tagColorEdit.color;
                                modifyBtn.closePopup();
                            }
                        }
                    }
                }
            }
        }
    }



    //MouseArea {
    //    anchors.fill: parent
    //    acceptedButtons: Qt.LeftButton | Qt.RightButton
    //    onClicked: {
    //        if (mouse.button === Qt.RightButton) {
    //            contextMenu.x = mouse.x;
    //            contextMenu.y = mouse.y;
    //
    //            contextMenu.open();
    //        }
    //    }
    //}
    //
    Menu {
        id: contextMenu

        MenuItem {
            Rectangle {
                id: itemTagColor

                anchors.left: parent.left
                anchors.top: parent.top
                color: "#4f92ff"

                width: 10
                height: parent.height
            }
            text: 'text'
            height: 30
        }

        MenuItem {
            text: 'text2'
            height: 30
        }
    }

}
