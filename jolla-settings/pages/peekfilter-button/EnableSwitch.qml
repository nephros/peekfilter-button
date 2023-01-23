/*
 * Copyright (c) 2023 Peter G. <sailfish@nephros.org>
 *
 * License: Apache-2.0
 *
 */

import QtQuick 2.1
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import com.jolla.settings 1.0
import org.nemomobile.systemsettings 1.0

SettingsToggle {
    id: enableSwitch

    checked: peekBoundary.value === 0
    active: checked

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

    //% "Swipe Lock: off"
    //: button status
    name: qsTrId("settings-peekfilter-button-status-off")
    //% "Swipe Lock: on"
    //: button status
    activeText: qsTrId("settings-peekfilter-button-status-on")

    icon.source: checked ? "image://theme/icon-m-peekfilter-lock" : "image://theme/icon-m-peekfilter-unlock"

    ConfigurationValue { id: peekBoundary
        key: "/desktop/lipstick-jolla-home/peekfilter/boundaryWidth"
        defaultValue: (peekBoundaryUser.value !== 0) ? peekBoundaryUser : undefined
    }
    ConfigurationValue { id: peekBoundaryUser
        key: "/desktop/lipstick-jolla-home/peekfilter/boundaryWidth_saved"
    }

    Timer {
        running: active
        interval: 2.5 * 60 * 1000
        onRunningChanged: {
            if (running) {
                console.info("BackgroundJob started.")
            } else {
                console.info("BackgroundJob stopped.")
            }
        }
        onTriggered: {
            setPeekBoundary( (peekBoundaryUser.value !== 0) ? peekBoundaryUser.value : undefined )
        }
    }

    function setPeekBoundary(n) {
        const i = Math.floor(n)
        if (i === 0) peekBoundaryUser.value = Math.floor(peekBoundary.value)
        peekBoundary.value = i
        console.info("Setting boundary values (i, user, new): ", i, peekBoundaryUser.value, peekBoundary.value)
    }

    menu: ContextMenu {
        SettingsMenuItem { onClicked: enableSwitch.goToSettings() }
        PeekSlider {
            value: peekBoundary.value
            onDownChanged: if (!down) enableSwitch.setPeekBoundary(sliderValue)
        }
    }
    onToggled: {
        if (!checked) {
            setPeekBoundary(0)
        } else {
            setPeekBoundary(peekBoundaryUser.value)
        }
    }
}
// vim: ft=javascript expandtab ts=4 sw=4 st=4
