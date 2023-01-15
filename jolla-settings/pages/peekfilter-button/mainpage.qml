import QtQuick 2.1
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

Page { id: page

    property alias currentValue: peekBoundary.value

    ConfigurationValue { id: peekBoundary
        key: "/desktop/lipstick-jolla-home/peekfilter/boundaryWidth"
        defaultValue: (peekBoundaryUser.value !== 0) ? peekBoundaryUser : 60
    }
    ConfigurationValue { id: peekBoundaryUser
        key: "/desktop/lipstick-jolla-home/peekfilter/boundaryWidth_saved"
    }

    function setPeekBoundary(n) {
        const i = Math.floor(n)
        console.info("Set peek boudary width to", i)
        if (i === 0) peekBoundaryUser.value = peekBoundary.value
        peekBoundary.value = i
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column { id: column
            width: page.width - Theme.horizontalPageMargin
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.paddingMedium

            PageHeader { title: qsTr("Edge Swipe") }

            Label {
                width: parent.width
                wrapMode: Text.Wrap
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("The edge boundary (a.k.a. Peek Boundary) describes the area at the edge of the screen which is recognized as an edge swipe gesture, as opposed to a swipe in an application window.")
            }
            Label {
                width: parent.width
                wrapMode: Text.Wrap
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Increasing the boundary can help when edge swipes are not recognized reliably.")
            }
            Label {
                width: parent.width
                wrapMode: Text.Wrap
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("For certain applications, like some games, it can be useful to reduce or disable the boundary completely.")
            }
            PeekSlider { id: slider
                value: peekBoundary.value
                onDownChanged: {
                    if (!down) {
                        page.setPeekBoundary(sliderValue)
                    }
                }
            }
            Label {
                width: parent.width - Theme.itemSizeSmall
                x: Theme.itemSizeSmall
                wrapMode: Text.Wrap
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: qsTr("Careful: setting this too low will result in you not being able to swipe away applications at all.")
            }

            Item {
                height: Theme.itemSizeLarge
                width: parent.width
            }
            Rectangle {
                property double factor: 0.4
                anchors.horizontalCenter: parent.horizontalCenter

                height: Screen.height * factor
                width: Screen.width * factor
                color: "transparent" //Theme.rgba(Theme.highlightColor, Theme.opacityFaint)

                radius: width / 10
                Image {
                    z: -1
                    anchors.fill: parent
                    anchors.centerIn: parent
                    source: Theme._homeBackgroundImage
                    sourceSize.height: parent.height
                    fillMode: Image.PreserveAspectCrop
                }
                Rectangle {
                    z: 10
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: page.currentValue * parent.factor
                    height: parent.height
                    color: Theme.rgba(Theme.highlightColor, Theme.opacityFaint)
                }
                Rectangle {
                    z: 10
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: page.currentValue * parent.factor
                    height: parent.height
                    color: Theme.rgba(Theme.highlightColor, Theme.opacityFaint)
                }

            }
        }
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
