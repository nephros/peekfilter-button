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
        property string name: qsTrId("settings-peekfilter-page")
        //% "Swipe Lock"
        //: button name in the top menu
        property string name: qsTrId("settings-peekfilter-button")
    }

    //% "Swipe Lock: off"
    //: button status
    name: qsTrId("settings-peekfilter-button-status-off")
    //% "Swipe Lock: on"
    //: button status
    activeText: qsTrId("settings-peekfilter-button-status-on")
    icon.source: "image://theme/icon-m-gesture"

    ConfigurationValue { id: peekBoundary
        key: "/desktop/lipstick-jolla-home/peekfilter/boundaryWidth"
        defaultValue: (peekBoundaryUser.value !== 0) ? peekBoundaryUser : 60
    }
    ConfigurationValue { id: peekBoundaryUser
        key: "/desktop/lipstick-jolla-home/peekfilter/boundaryWidth_saved"
    }

    function setPeekBoundary(n) {
        const i = Math.floor(n)
        if (i === 0) peekBoundaryUser.value = Math.floor(peekBoundary.value)
        peekBoundary.value = i
        console.debug("Setting values (i, user, new): ", i, peekBoundaryUser.value, peekBoundary.value)
    }

    menu: ContextMenu {
        SettingsMenuItem { onClicked: enableSwitch.goToSettings() }
        PeekSlider {
            value: peekBoundary.value
            onDownChanged: (down) ? 0 : enableSwitch.setPeekBoundary(sliderValue)
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
