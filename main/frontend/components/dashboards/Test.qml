import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.0
import QtQml.Models 2.2
import QtQuick.Controls.Material 2.12

import '..'

SplitView {
    property string name: 'Test'
    Rectangle {
    color: "#303030"
    SplitView.fillWidth: true
        SplitView.fillHeight: true
        SplitView.preferredWidth: 600
    ColumnLayout {
        id: settingsColumn

        GroupBox {
            id: dataBox
            title: 'Data'
            Layout.fillWidth: true
            Layout.fillHeight: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                Button {
                    text: "Choose File"
                }
            }
        }
    }
    }
    Rectangle {
        Material.theme: Material.Dark
        SplitView.fillWidth: true
        SplitView.fillHeight: true
        SplitView.preferredWidth: 600
    ColumnLayout {
        id: settingsColumn2

        GroupBox {
            id: dataBox2
            title: 'Data'
            Layout.fillWidth: true
            Layout.fillHeight: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                Button {
                    text: "Choose File"
                }
            }
        }
    }
    }
}