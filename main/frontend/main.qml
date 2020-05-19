import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

import 'components'
import 'components/dashboards'

ApplicationWindow {
    id: window
    visible: true
    minimumHeight: 700
    minimumWidth: 1600
    Material.theme: Material.Dark
    Material.accent: Material.Green
    title: 'Regression app'

    Pane {
        id: body
        anchors.fill: parent
        NoteBook {
            Regression {}
            Forecast {}
            Options {}
        }
    }
}
