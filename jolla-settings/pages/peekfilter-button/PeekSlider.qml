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
    //: app name in the settings
    label: qsTrId("settings-peekfilter-controls-slider")

    stepSize: 4; minimumValue: 0; maximumValue: 120
    valueText: sliderValue + "px"
    color: (value < 40) ? Theme.highlightFromColor("orange", Theme.colorScheme) : Theme.lightPrimaryColor
}

// vim: ft=javascript expandtab ts=4 sw=4 st=4
