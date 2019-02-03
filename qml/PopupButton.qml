import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0


Item {
    id: popupRoot

    signal popped()

    property alias component : itemLoader.sourceComponent
    property alias loaderItem : itemLoader.item
    property alias buttonIconSource : addBtn.icon.source

    property real popupWidth: 100
    property real popupHeight: 100
    property real buttonSize: 32

    function openPopup() {
        _applicationData.updatePopupBackground();
        popupCentralWgt.x = addBtn.mapToItem(null, 0, 0).x;
        popupCentralWgt.y = addBtn.mapToItem(null, 0, 0).y;

        // Force Refresh
        var tmp = image.source;
        image.source = "";
        image.source = tmp;

        popupBackground.state = "slide";
    }

    function closePopup() {
        itemLoader.active = false;
        popupBackground.closeBg()
    }

    width: buttonSize
    height: buttonSize

    RoundButton {
        id: addBtn

        highlighted: true

        icon.source: "qrc:/add.png"

        Material.accent: "#2196F3"
        font.pixelSize: 20
        width: buttonSize
        height: buttonSize

        onPressed: {
            popupRoot.openPopup()
        }
    }

    Rectangle {
        id: popupBackground

        function closeBg() {
            state = "close"
        }

        parent: ApplicationWindow.overlay

        anchors.fill: parent

        visible: (state == "close" && !popupCloseTrs.running) ? false : true

        state: "close"

        states: [
            State {
                name: "slide"
                PropertyChanges { target: popupCentralWgt; x: (popupBackground.width - addBtn.width) / 2; y: (popupBackground.height - addBtn.height) / 2 }
                PropertyChanges { target: popupDarkerRect; opacity: 0.3 }
            },
            State {
                name: "open"
                PropertyChanges { target: popupCentralWgt; x: (popupBackground.width - popupWidth) / 2; y: (popupBackground.height - popupHeight) / 2 }
                PropertyChanges { target: popupCentralWgt; width: popupWidth; height: popupHeight }
                PropertyChanges { target: popupCentralWgt; radius: 2 }
                PropertyChanges { target: popupDarkerRect; opacity: 0.3 }
            },
            State {
                name: "close"
                PropertyChanges { target: popupCentralWgt; x: addBtn.mapToItem(null, 0, 0).x; y: addBtn.mapToItem(null, 0, 0).y }
                PropertyChanges { target: popupCentralWgt; width: addBtn.width; height: addBtn.height;  }
                PropertyChanges { target: popupCentralWgt; radius: addBtn.radius }
                PropertyChanges { target:  popupDarkerRect; opacity: 0.0 }
            }
        ]

        transitions: [
            Transition {
                id: popupSlideTrs
                from: "close"
                to: "slide"
                NumberAnimation { properties: "x,y"; duration: 350; easing.type: Easing.OutBack}
                NumberAnimation { property: "opacity"; duration: 200 }

                onRunningChanged: {
                    if(popupBackground.state == "slide" && !running)
                        popupBackground.state = "open";
                }
            },
            Transition {
                id: popupOpenTrs
                from: "slide"
                to: "open"
                NumberAnimation { properties: "x,y"; duration: 200; }
                NumberAnimation { properties: "width,height"; duration: 200 }
                NumberAnimation { properties: "radius"; duration: 200 }

                onRunningChanged: {
                    if(popupBackground.state == "open" && !running)
                    {
                        itemLoader.active = true;
                    }
                }
            },
            Transition {
                id: popupCloseTrs
                from: "open"
                to: "close"
                NumberAnimation { properties: "width,height"; duration: 200 }
                NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.InBack }
                NumberAnimation { property: "opacity"; duration: 200 }
                NumberAnimation { properties: "radius"; duration: 200 }
            }
        ]


        Image {
            id: image

            anchors.fill: parent

            source: "file:popupBackground.png"
            cache: false
        }

        ShaderEffectSource {
            id: effectSource

            anchors.centerIn: image
            anchors.fill: image

            sourceItem: image
            sourceRect: Qt.rect(x,y, width, height)
        }

        FastBlur{
            id: blur

            anchors.fill: effectSource

            source: effectSource
            radius: 20
        }

        Rectangle {
            id: popupDarkerRect
            anchors.fill: parent
            color: "black"
            //opacity: 0.3

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var mapped = mapToItem(popupCentralWgt, mouse.x, mouse.y)
                    var contained = popupCentralWgt.contains(mapped)

                    if(contained)
                    {
                        return;
                    }

                    popupRoot.closePopup();
                }
            }
        }

        Rectangle {
            id: popupCentralWgt

            width: addBtn.width
            height: addBtn.height

            radius: addBtn.radius
            color: "#404040"

            Loader {
                id: itemLoader
                active: false
                anchors.centerIn: parent

                onLoaded: popupRoot.popped()
            }
        }
    }
}
