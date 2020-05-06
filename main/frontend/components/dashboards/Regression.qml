import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1
import QtCharts 2.3
import QtQuick.Dialogs 1.0
import QtQml.Models 2.2

import '..'

Page {
    name: 'Regression'
    ColumnLayout {
        GroupBox {
            id: dataBox
            title: 'Data'
            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                Button {
                    text: "Choose File"
                    onClicked: fileDialog.open()
                }
                FileDialog {
                    id: fileDialog
                    title: "Please choose a file"
                    folder: shortcuts.home
                    onAccepted: () => {
                        r_manager.load_data(fileDialog.fileUrl)
                        table_model.load_data(fileDialog.fileUrl)
                        fileDialog.close()
                    }
                    onRejected: {
                        console.log("Canceled")
                        fileDialog.close()
                    }
                    Component.onCompleted: visible = false
                }
                Button {
                    text: "Run Regression"
                    onClicked: r_manager.get_df(table_model.get_data())
                }
            }
        }
        GroupBox {
            id: regressionSettingsBox
            title: 'Regression settings'
            Layout.fillWidth: true
            Layout.fillHeight: true
            GridLayout {
                anchors.fill: parent
                columns: 1
                rows: 1
                List {}
            }
        }
    }
    ColumnLayout {
        GroupBox {
            id: resultBox
            title: 'Result'
            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                Text {
                     id: resultText
                     anchors.fill: parent
                     textFormat: Text.RichText
                     text: r_manager.summary
                }

            }
        }
    }
}