import QtQuick 2.1
import Sailfish.Silica 1.0
import Nemo.DBus 2.0
import Nemo.Configuration 1.0

Page { id: root

    property alias quickToggle: experimentalConfigs.quickAppToggleGesture
    ConfigurationGroup {
        id: experimentalConfigs
        path: "/desktop/sailfish/experimental"
        property bool quickAppToggleGesture: false
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            //% "Reset to default"
            //: menu entry
            MenuItem { text: qsTrId("settings-peekfilter-menu-reset")
                onDelayedClick: {
                    // setting a dconf key to undefined should 'dconf reset' it.
                    experimentalConfigs.clear()
                }
            }
        }
        Column { id: column
            width: page.width - Theme.horizontalPageMargin
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.paddingMedium

            //% "Experimental Features"
            //: Settings page title
            PageHeader { title: qsTrId("settings-peekfilter-page-adv-title") }

            //% "Quick App Switching"
            //: section header
            SectionHeader { text: qsTrId("settings-peekfilter-page-adv-section-quicksw") }

            Label {
                width: parent.width
                wrapMode: Text.Wrap
                color: Theme.secondaryHighlightColor
                textFormat: Text.StyledText
                font.pixelSize: Theme.fontSizeSmall
                //% "Similar to pressing Alt + Tab on a desktop to switch to the previous app window. However, Quick App Switching can only jump to the previous app."
                text: qsTrId("settings-peekfilter-page-adv-label-1")
            }
            TextSwitch{ id: quickToggleSwitch
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                checked: root.quickToggle
                automaticCheck: true
                //% "Quick App Switching"
                //: quick app switch text
                text: qsTrId("settings-peekfilter-quicksw-name")
                //% "Once enabled you can switch from the foregound app to the previous one by doing a long peek gesture."
                //: quick app switch description
                description: qsTrId("settings-peekfilter-quicksw-desc")
                onClicked: root.quickToggle = !root.quickToggle
            }
            LinkedLabel {
                width: parent.width
                wrapMode: Text.Wrap
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall
                //% "For more information, see: %1"
                plainText: qsTrId("settings-peekfilter-page-adv-label-2").arg("https://docs.sailfishos.org/Reference/Sailfish_OS_Tips_and_Tricks/#quick-app-switching")
                shortenUrl: true
            }
        }
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
