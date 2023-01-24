/*
 * Copyright (c) 2023 Peter G. <sailfish@nephros.org>
 *
 * License: Apache-2.0
 *
 */

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
        onValueChanged: console.debug("peekBoundary is now", typeof(value), value)
    }
    ConfigurationValue { id: peekBoundaryUser
        key: "/desktop/lipstick-jolla-home/peekfilter/boundaryWidth_saved"
        onValueChanged: console.debug("peekBoundaryUser is now", typeof(value), value)
    }

    Timer {
        running: (active && DeviceLock.enabled && timeout > 0)
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
        onTriggered: resetPeekBoundary()
        Component.onCompleted: console.debug(qsTr("Swipe Lock: Device Lock is %1 enabled with timeout %2, %1 arming Timer.").arg(DeviceLock.enabled ? "" : "not").arg(DeviceLock.automaticLocking))
    }

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
                    if (result !== 0) { enableSwitch.resetPeekBoundary() }
                },
                function(error, message) { console.warn("Swipe Lock: Call failed:", error, message) }
            )
        }
    }

    function resetPeekBoundary() {
        console.info("Swipe Lock: Resetting boundary values.")
        setPeekBoundary( (peekBoundaryUser.value !== 0) ? peekBoundaryUser.value : undefined )
    }

    function setPeekBoundary(n) {
        console.debug("Swipe Lock: Setting boundary values (n, user, new): ", n, peekBoundaryUser.value, peekBoundary.value)
        if ( n > 1) {
            peekBoundary.value = Math.floor(n)
        } else {
            if (peekBoundary.value) peekBoundaryUser.value = Math.floor(peekBoundary.value)
            peekBoundary.value = 0
        }
        console.debug("Swipe Lock: Boundary values now: (n, user, new): ", n, peekBoundaryUser.value, peekBoundary.value)
    }

    menu: ContextMenu {
        SettingsMenuItem { onClicked: enableSwitch.goToSettings() }
        PeekSlider {
            value: peekBoundary.value
            onDownChanged: if (!down) enableSwitch.setPeekBoundary(boundary)
        }
    }
    onToggled: {
        if (!checked) {
            console.info("Swipe Lock: engaged.")
            setPeekBoundary(0)
        } else {
            console.info("Swipe Lock: dis-engaged.")
            setPeekBoundary(peekBoundaryUser.value)
        }
    }
    Component.onCompleted: console.info("Swipe Lock v@@UNRELEASED@@ loaded.")
}
// vim: ft=javascript expandtab ts=4 sw=4 st=4
