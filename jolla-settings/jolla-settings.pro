TEMPLATE = aux

CONFIG += sailfishapp_i18n_idbased

settings-entry.path = /usr/share/jolla-settings/entries
settings-entry.files = ./entries/peekfilter-button.json

settings-ui.path = /usr/share/jolla-settings/pages/peekfilter-button
settings-ui.files = \
    pages/peekfilter-button/mainpage.qml \
    pages/peekfilter-button/PeekSlider.qml \
    pages/peekfilter-button/EnableSwitch.qml

INSTALLS += settings-ui settings-entry
OTHER_FILES += test.qml

lupdate_only {
    SOURCES += pages/*.qml
}

TRANSLATIONS += translations/peekfilter-button-en.ts \
                translations/peekfilter-button-de.ts

include(entries/entries.pri)
include(translations/translations.pri)
