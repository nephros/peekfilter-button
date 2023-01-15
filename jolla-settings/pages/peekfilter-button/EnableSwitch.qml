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

    name: qsTr("Swipe Lock off")
    activeText: qsTr("Swipe Lock on")
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
