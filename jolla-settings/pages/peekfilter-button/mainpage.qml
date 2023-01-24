import QtQuick 2.1
import Sailfish.Silica 1.0
import Nemo.DBus 2.0
import Nemo.Configuration 1.0

Page { id: page

    /*
     * this is just here to have IDs for translations used in entries.json
     */
    QtObject {
        //% "Edge Swipe"
        //: entry name in the settings
        property string pagename: qsTrId("settings-peekfilter-page")
        //% "Swipe Lock"
        //: button name in the top menu
        property string buttonname: qsTrId("settings-peekfilter-button")
    }

    /*
     * from /usr/share/lipstick-jolla-home-qt5/compositor.qml, Line 214
     *
        ConfigurationGroup {
            id: peekFilterConfigs
            path: "/desktop/lipstick-jolla-home/peekfilter"
            property int boundaryWidth: Theme.paddingLarge
            property int boundaryHeight: Theme.paddingLarge
            property int keyboardBoundaryWidth: boundaryWidth / 2
            property int keyboardBoundaryHeight: boundaryHeight / 2
            property int pressDelay: 400
        }
    */


    ConfigurationValue { id: peekBoundary
        key: "/desktop/lipstick-jolla-home/peekfilter/boundaryWidth"
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
        if ( n > 1) {
            peekBoundary.value = Math.floor(n)
        } else {
            if (peekBoundary.value) peekBoundaryUser.value = Math.floor(peekBoundary.value)
            peekBoundary.value = 0
        }
        console.info("Setting boundary values (n, user, new): ", n, peekBoundaryUser.value, peekBoundary.value)
    }

    property bool sliderDown: false

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            //% "Reset to default"
            //: menu entry
            MenuItem { text: qsTrId("settings-peekfilter-menu-reset")
                onDelayedClick: {
                    // setting a dconf key to undefined should 'dconf reset' it.
                    peekBoundary.value     = undefined;
                    peekBoundaryUser.value = undefined;
                    // close the page so the values are loaded again at next opening
                    pageStack.navigateBack()
                }
            }
        }
        Column { id: column
            width: page.width - Theme.horizontalPageMargin
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.paddingMedium

            //% "Edge Swipe"
            //: Settings page title
            PageHeader { title: qsTrId("settings-peekfilter-page-title") }

            //% "Edge Width"
            //: section header
            SectionHeader { text: qsTrId("settings-peekfilter-page-section-swipe") }

            Label {
                width: parent.width
                wrapMode: Text.Wrap
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall
                //% "The slider below allows to adjust the area of the screen recognized as an 'Edge Swipe' gesture (as opposed to a swipe within an app window)."
                text: qsTrId("settings-peekfilter-page-label-1")
            }
            LinkedLabel {
                width: parent.width
                wrapMode: Text.Wrap
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall
                //% "Adjusting this can help when edge swipes are not recognized reliably. For more information, see https://docs.sailfishos.org/Reference/Sailfish_OS_Tips_and_Tricks/#easing-edge-swipe"
                plainText: qsTrId("settings-peekfilter-page-label-2")
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
                Rectangle {
                    z: 15
                    clip: true
                    anchors.centerIn: parent
                    width: parent.width + border.width * 2
                    height: parent.height + border.width * 2
                    color: "transparent" //Theme.rgba(Theme.highlightColor, Theme.opacityFaint)
                    border.color: "black"
                    border.width:  Theme.paddingMedium
                    radius: width / 15

                }
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
                value: peekBoundary.value
                onDownChanged: {
                    if (!down) page.setPeekBoundary(boundary)
                    sliderDown = down
                }
            }
            Label {
                width: parent.width - Theme.itemSizeSmall
                x: Theme.itemSizeSmall
                wrapMode: Text.Wrap
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                textFormat: Text.StyledText
                //% "Careful: setting this too low will result in you not being able to swipe away applications at all."
                text: qsTrId("settings-peekfilter-page-label-3")
            }

            //% "Swipe Lock"
            //: section header
            SectionHeader { text: qsTrId("settings-peekfilter-button") }

            Label {
                width: parent.width
                wrapMode: Text.Wrap
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall
                textFormat: Text.StyledText
                //% "For certain apps it can be useful to disable the edge swipe completely. To do that you can add the '%1' button control to the Top Menu."
                text: Theme.highlightText(
                        qsTrId("settings-peekfilter-page-label-4").arg(qsTrId("settings-peekfilter-button")),
                        qsTrId("settings-peekfilter-button"),
                        Theme.highlightColor
                      )
                    + "<br />"
                    //% "Notice: As a safety measure, %1 will disable itself automatically shortly before the device lock engages."
                    + qsTrId("settings-peekfilter-page-label-5").arg(qsTrId("settings-peekfilter-button"))
            }
            ValueButton {
                //% "Top Menu Settings"
                label: qsTrId("settings-peekfilter-page-topmenu-settings-name")
                //% "Look for '%1'"
                //: %1 is the button name (id: settings-peekfilter-button)
                description: qsTrId("settings-peekfilter-page-topmenu-settings-hint").arg(qsTrId("settings-peekfilter-button"));
                onClicked: { settings.open("system_settings/look_and_feel/topmenu") }
            }
        }
    }
    Rectangle {
        z: 10
        visible: sliderDown
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: slider.value
        height: parent.height
        color: Theme.rgba(((width < Theme.paddingLarge/2) ? "red" : Theme.highlightColor), Theme.opacityFaint)
    }
    Rectangle {
        z: 10
        visible: sliderDown
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: slider.value
        height: parent.height
        color: Theme.rgba(((width < Theme.paddingLarge/2) ? "red" : Theme.highlightColor), Theme.opacityFaint)
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
