TEMPLATE = aux
CONFIG += sailfishapp_no_deploy_qml sailfishapp_i18n_idbased

lupdate_only {
    SOURCES += entries/*.qml
}
