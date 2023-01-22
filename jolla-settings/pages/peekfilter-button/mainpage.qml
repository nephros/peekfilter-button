import QtQuick 2.1
import Sailfish.Silica 1.0
import Nemo.DBus 2.0
import Nemo.Configuration 1.0

Page { id: page

    /* string is just here to get caught for translations */
    property string titledummy: qsTr("Edge Swipe", "title of the Settings entry")

    ConfigurationValue { id: peekBoundary
        key: "/desktop/lipstick-jolla-home/peekfilter/boundaryWidth"
        defaultValue: (peekBoundaryUser.value !== 0) ? peekBoundaryUser : 60
    }
    ConfigurationValue { id: peekBoundaryUser
        key: "/desktop/lipstick-jolla-home/peekfilter/boundaryWidth_saved"
    }
    DBusInterface { id: settings
        service: "com.jolla.settings"
        path: "/com/jolla/settings/ui"
        iface: "com.jolla.settings.ui"
        function open(page) {
            call ("showPage", [ page ], function(){},function(){})
        }
    }

    function setPeekBoundary(n) {
        const i = Math.floor(n)
        if (i === 0) {
            peekBoundaryUser.value = Math.floor(peekBoundary.value)
        }
        peekBoundary.value = i
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem { text: qsTr("Reset to default")
                onClicked: {
                peekBoundary.value = undefined;
                peekBoundaryUser.value = undefined;
                pageStack.navigateBack()
                }
            }
        }
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
                text: qsTr("The slider below enables you to configure the area of the screen which is recognized as an 'Edge Swipe' gesture (as opposed to a swipe within an application window).")
            }
            LinkedLabel {
                width: parent.width
                wrapMode: Text.Wrap
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                plainText: qsTr("Adjusting this can help when edge swipes are not recognized reliably. For more information, see https://docs.sailfishos.org/Reference/Sailfish_OS_Tips_and_Tricks/#easing-edge-swipe")
                shortenUrl: true
            }
            Item {
                height: Theme.paddingLarge
                width: parent.width
            }
            Rectangle {
                property double factor: 0.3
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
                    width: slider.value * parent.factor
                    height: parent.height
                    color: Theme.rgba(Theme.highlightColor, Theme.opacityFaint)
                }
                Rectangle {
                    z: 10
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: slider.value * parent.factor
                    height: parent.height
                    color: Theme.rgba(Theme.highlightColor, Theme.opacityFaint)
                }

            }
            Item {
                height: Theme.paddingLarge
                width: parent.width
            }
            PeekSlider { id: slider
                value: peekBoundary.value ? peekBoundary.value : peekBoundary.defaultValue
                onDownChanged: (down) ? 0 : page.setPeekBoundary(sliderValue)
            }
            Label {
                width: parent.width - Theme.itemSizeSmall
                x: Theme.itemSizeSmall
                wrapMode: Text.Wrap
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: qsTr("Careful: setting this too low will result in you not being able to swipe away applications at all.")
            }

            SectionHeader { text: qsTr("Swipe Lock") }

            Label {
                width: parent.width
                wrapMode: Text.Wrap
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("For certain applications (like some games) it can be useful to reduce or disable the boundary completely. The most convenient way to do that is to add the Swipe Lock button control to the Top Menu.")
            }
            ValueButton {
                label: qsTr("Top Menu Settings")
                description: qsTr('Look for "%1"').arg("Swipe Lock");
                //onClicked: pageStack.push(Qt.resolvedUrl("../topmenu/topmenu.qml"))
                onClicked: { settings.open("system_settings/look_and_feel/topmenu") }
            }
        }
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
