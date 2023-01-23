/*
 * Copyright (c) 2023 Peter G. <sailfish@nephros.org>
 *
 * License: Apache-2.0
 *
 */
import QtQuick 2.1
import Sailfish.Silica 1.0

Slider { id: slider
    width: parent.width

    //% "Edge width"
    //: peek slider label
    label: qsTrId("settings-peekfilter-controls-slider")

    stepSize: 4; minimumValue: 0; maximumValue: Screen.width / 8
    valueText: Math.floor(sliderValue) + "px"
    color: {
        if (sliderValue < Theme.paddingLarge/2) return Theme.highlightFromColor("red", Theme.colorScheme)
        if (value < Theme.paddingMedium)        return Theme.highlightFromColor("orange", Theme.colorScheme)
        return Theme.lightPrimaryColor
    }
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
