/*
 * Copyright (c) 2023 Peter G. <sailfish@nephros.org>
 *
 */

// SPDX-License-Identifier: Apache-2.0

import QtQuick 2.1
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import Nemo.DBus 2.0
import com.jolla.settings 1.0
import org.nemomobile.devicelock 1.0
import org.nemomobile.systemsettings 1.0

SettingsToggle {
    id: enableSwitch

    checked: peekBoundary.value === 0
    active: checked

    //% "Swipe Lock: off"
    //: button status
    name: qsTrId("settings-peekfilter-button-status-off")
    //% "Swipe Lock: on"
    //: button status
    activeText: qsTrId("settings-peekfilter-button-status-on")

    icon.source: checked ? "image://theme/icon-m-peekfilter-lock" : "image://theme/icon-m-peekfilter-unlock"

    menu: ContextMenu {
        SettingsMenuItem { onClicked: enableSwitch.goToSettings() }
        PeekSlider {
            value: peekBoundary.value
            onDownChanged: if (!down) peekBoundary.value = boundary
        }
    }

    onToggled: {
        if (!checked) {
            console.info("Swipe Lock: engaged.")
            disableSwipes()
        } else {
            console.info("Swipe Lock: dis-engaged.")
            enableSwipes()
        }
    }

    Component.onCompleted: {
        console.info("Swipe Lock v@@UNRELEASED@@ loaded.")
        if (peekBoundaryStored) {
            peekBoundaryUser = Math.floor(peekBoundaryStored)
        } else if (peekBoundary && (peekBoundary !== 0)) {
            peekBoundaryUser = Math.floor(peekBoundary)
        }
    }

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

    function enableSwipes() {
        console.info("Swipe Lock: enabling Swipes.")
        peekBoundary.value = Math.floor((peekBoundaryUser && (peekBoundaryUser !== 0)) ? peekBoundaryUser : undefined )
    }
    function disableSwipes() {
        console.info("Swipe Lock: disabling Swipes.")
        if (peekBoundary.value && (peekBoundary.value !== 0)) peekBoundaryUser = Math.floor(peekBoundary.value)
        peekBoundary.value = 0
    }

    ConfigurationValue { id: peekBoundary
        key: "/desktop/lipstick-jolla-home/peekfilter/boundaryWidth"
        onValueChanged: console.info("peekBoundary is now", typeof(value), value)
    }

    // replace the dconf key, we live in Lipstick so we have persistent-enough State.
    property int peekBoundaryUser

    // previously: peekBoundaryUser
    ConfigurationValue { id: peekBoundaryStored
        key: "/desktop/lipstick-jolla-home/peekfilter/boundaryWidth_saved"
        //TODO/FIXME: do we want to detect and react on changes from the settings app?
        onValueChanged: console.info("peekBoundaryStored is now", typeof(value), value)
    }

    /*
     * when toggled, start a time to unlock again before the lock engages
     */
    Timer {
        running: (active && DeviceLock.enabled && (timeout > 0))
        // automaticLocking is in minutes, lets reset 10 seconds before that:
        property int timeout: ((DeviceLock.automaticLocking * 60) - 10) * 1000
        interval: (timeout > 0) ? timeout : 0
        onRunningChanged: {
            if (running) {
                console.info("Swipe Lock: Reset timer started:", Math.floor(interval/1000) + "s")
            } else {
                console.info("Swipe Lock: Reset timer stopped.")
            }
        }
        onTriggered: if (active) enableSwipes()
        Component.onCompleted: console.info(qsTr("Swipe Lock: Device Lock is %1 enabled with timeout %2, %3 arming Timer.").arg(DeviceLock.enabled ? "" : "not").arg(DeviceLock.automaticLocking).arg(running ? "" : "not" ))
    }

    /*
     * monitor DBus to detect lock/unlock events
     */
    DBusInterface { id: lockbus
        bus: DBus.SystemBus
        service: 'org.nemomobile.devicelock'
        path:    '/devicelock'
        iface:   'org.nemomobile.lipstick.devicelock'

        signalsEnabled: true
        function stateChanged() {
            console.info("Swipe Lock: Device Lock stateChanged signal")
            call("state",undefined,function(result) {
                    console.info("Swipe Lock: Device lock state:", result)
                    if (result !== 0) { enableSwitch.enableSwipes() }
                },
                function(error, message) { console.warn("Swipe Lock: Call failed:", error, message) }
            )
        }
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
