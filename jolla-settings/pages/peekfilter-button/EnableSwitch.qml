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

    property bool activeState: peekBoundary.value === 0

    name: qsTr("Edge Swipe")
    activeText: qsTr("Edge: %1px").arg(peekBoundary.value)
    icon.source: "image://theme/icon-m-gesture"

    active: !activeState
    checked: !activeState

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

    Component.onCompleted: peekBoundaryUser.value = peekBoundary.value

    menu: ContextMenu {
        SettingsMenuItem { onClicked: enableSwitch.goToSettings() }
        PeekSlider {
            value: peekBoundary.value
            onDownChanged: {
                if (!down) {
                    enableSwitch.setPeekBoundary(sliderValue)
                }
            }
        }
        MenuItem { text: qsTr("Reset"); onClicked: peekBoundary.value = peekBoundary.defaultValue }
    }
    onToggled: {
        if (!checked) {
            peekBoundaryUser.value = peekBoundary.value
            setPeekBoundary(0)
        } else {
            setPeekBoundary(peekBoundaryUser.value)
        }
    }

}
// vim: ft=javascript expandtab ts=4 sw=4 st=4
