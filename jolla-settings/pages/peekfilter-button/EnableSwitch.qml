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
//import org.nemomobile.devicelock 1.0
import org.nemomobile.systemsettings 1.0

SettingsToggle {
    id: enableSwitch

    checked: peekBoundary.value === 0
    active: checked

    //% "Swipe Lock: off"
    //: top menu button status text
    name: qsTrId("settings-peekfilter-button-status-off")
    //% "Swipe Lock: on"
    //: top menu button status text
    activeText: qsTrId("settings-peekfilter-button-status-on")
    //this is just here to have IDs for translations used in entries.json
    //% "Swipe Lock"
    //: button name in the top menu
    property string buttonname: qsTrId("settings-peekfilter-button")


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
        if (peekBoundary && (peekBoundary !== 0)) peekBoundaryUser = Math.floor(peekBoundary)
    }

    function enableSwipes() {
        if (peekBoundary.value !== 0) return
        console.info("Swipe Lock: enabling Swipes.")
        peekBoundary.value = Math.floor((peekBoundaryUser && (peekBoundaryUser !== 0)) ? peekBoundaryUser : undefined )
    }
    function disableSwipes() {
        if (peekBoundary.value === 0) return
        console.info("Swipe Lock: disabling Swipes.")
        if (peekBoundary.value && (peekBoundary.value !== 0)) peekBoundaryUser = Math.floor(peekBoundary.value)
        peekBoundary.value = 0
    }

    ConfigurationValue { id: peekBoundary
        key: "/desktop/lipstick-jolla-home/peekfilter/boundaryWidth"
        onValueChanged: console.debug("peekBoundary is now", value)
    }

    // replace the dconf key, we live in Lipstick so we have persistent-enough State.
    property int peekBoundaryUser

    // formerly peekBoundary, deprecated, kept here for a while to remove extant keys
    ConfigurationValue {
        key: "/desktop/lipstick-jolla-home/peekfilter/boundaryWidth_saved"
        Component.onCompleted: if (value)  value = undefined
    }

    /*
     * when toggled, start a timer to unlock again before the lock engages
     */
    /*
    Timer {
        running: (active && DeviceLock.enabled && (timeout > 0))
        // automaticLocking is in minutes, lets reset 10 seconds before that:
        property int timeout: ((DeviceLock.automaticLocking * 60) - 5) * 1000
        interval: (timeout > 0) ? timeout : 0
        onRunningChanged: {
            if (running) {
                console.info("Swipe Lock: Reset timer started")
            } else {
                console.info("Swipe Lock: Reset timer stopped.")
            }
        }
        onTriggered: if (active) enableSwipes()
        Component.onCompleted: console.info("Swipe Lock: Device Lock is",
                                (DeviceLock.enabled ? "enabled" : "not enabled"),
                                "with timeout", DeviceLock.automaticLocking,
                                ", we are", (active) ? "engaged" : "not engaged",
                                ", therefore", (running ? "arming" : "not arming" ),
                                "Timer triggering in", Math.floor(interval/1000), "s"
                            )
    }
     */

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
            console.debug("Swipe Lock: Device Lock stateChanged signal")
            call("state",undefined,function(result) {
                    console.debug("Swipe Lock: Device lock state:", result)
                    if (result !== 0) { enableSwitch.enableSwipes() }
                },
                function(error, message) { console.warn("Swipe Lock: Call failed:", error, message) }
            )
        }
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
