import QtQuick 2.7
import QtQuick.Controls.Material 2.2

import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0

import QtGraphicalEffects 1.0


ApplicationWindow {
    id: rootApp

    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    //flags: Qt.FramelessWindowHint

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        interactive: false

        Page {
            Calendar {
                id: calendarID

                width: parent.width
                height: 50

                minimumDate: new Date(2017, 0, 1)
                maximumDate: new Date(2018, 0, 1)

                frameVisible: true

                style: CalendarStyle{
                    dayDelegate: null
                    gridVisible: false
                    dayOfWeekDelegate: null
                    weekNumberDelegate: null

                    navigationBar: Rectangle {
                            color: "#4c4c4c" // 2196F3
                            height: calendarID.height

                            ToolButton {
                                id: previousMonth

                                width: parent.height
                                height: width

                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left

                                onClicked: control.showPreviousMonth()

                                Image {
                                    source: "qrc:/arrow_left.png"
                                    anchors.fill: parent
                                    anchors.centerIn: parent
                                    anchors.margins: parent.width / 4
                                }
                            }

                            Label {
                                id: dateText

                                anchors.verticalCenter: parent.verticalCenter

                                anchors.left: previousMonth.right
                                anchors.leftMargin: 2

                                anchors.right: nextMonth.left
                                anchors.rightMargin: 2

                                text: styleData.title

                                fontSizeMode: Text.Fit
                                font.pixelSize: 24

                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            ToolButton {
                                id: nextMonth

                                width: parent.height
                                height: width

                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right

                                onClicked: control.showNextMonth()

                                Image {
                                    source: "qrc:/arrow_right.png"

                                    anchors.fill: parent
                                    anchors.centerIn: parent
                                    anchors.margins: parent.width / 4
                                }
                            }
                        }
                }
            }


            ListView {
                id: noteView

                anchors.top: calendarID.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 10
                anchors.bottomMargin: 10

                width: parent.width
                height: parent.height

                spacing: 10
                clip: true

                model: noteModel

                delegate: Note {
                    id: note

                    width: noteView.width * 0.9
                    anchors.horizontalCenter: parent.horizontalCenter

                    noteObj: modelData //reportModel[index]
                }

                ScrollBar.vertical: ScrollBar {policy: ScrollBar.AlwaysOn}
            }
        }

        Page {
            PopupButton{
                id: addTagBtn

                anchors.horizontalCenter: parent.horizontalCenter
                //anchors.verticalCenter: parent.verticalCenter

                popupWidth: 500
                popupHeight: 200
                buttonSize: 50

                onPopped: {
                    //loaderItem.pTagName = tagObj ? tagObj.name : ""
                    //loaderItem.pTagColor = tagObj ? tagObj.color : "white"
                }

                component: Item {
                    id: itemWgt

                    width: addTagBtn.popupWidth
                    height: addTagBtn.popupHeight

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
                                    onClicked: addTagBtn.closePopup()
                                }

                                Button {
                                    text: "OK"
                                    onClicked: {
                                        _applicationData.createTag(tagNameEdit.text, tagColorEdit.color);
                                        addTagBtn.closePopup();
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ListView {
                id: tagView

                width: parent.width
                height: parent.height - addTagBtn.height

                anchors.top: addTagBtn.bottom
                spacing: 10
                clip: true

                model: tagModel

                delegate: TagItem {
                    id: tagItem
                    tagObj: modelData
                    width : 2/3 * tagView.width

                    anchors.horizontalCenter: parent.horizontalCenter
                }

                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AlwaysOn }
            }
        }

        Page {
            Text{
                anchors.centerIn: parent

                color: "white"
                font.pixelSize: 30

                text: "Later"
            }
        }
    }

    header: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            text: qsTr("Task")
        }
        TabButton {
            text: qsTr("Tag")
        }
        TabButton {
            text: qsTr("Statistics")
        }
    }
}
