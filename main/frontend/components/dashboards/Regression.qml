import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.0
import QtQml.Models 2.2

import '..'

Page {
    name: 'Regression'
    Rectangle {
        color: "#303030"
        SplitView.fillWidth: true
        SplitView.fillHeight: true
        SplitView.preferredWidth: 600
        ColumnLayout {
            anchors.fill: parent
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
                            fileDialog.close()
                        }
                        Component.onCompleted: visible = false
                    }
                    Button {
                        text: "Run Regression"
                        onClicked: () => {
                            r_manager.get_df(table_model.get_data())
                            r_manager.run_regression()
                        }
                    }
                }
            }
            GroupBox {
                id: regressionSettingsBox
                title: 'Regression settings'
                Layout.fillWidth: true
                Layout.fillHeight: true
                RowLayout {
                    anchors.fill: parent
                    List {}
                }
            }
        }
    }
    Rectangle {
        color: "#303030"
        SplitView.fillWidth: true
        SplitView.fillHeight: true
        SplitView.preferredWidth: 1000
        ColumnLayout {
            anchors.fill: parent
            GroupBox {
                id: resultBox
                title: 'Result'
                Layout.fillWidth: true
                Layout.fillHeight: true
                GridLayout {
                    anchors.fill: parent
                    columns: 1
                    Text {
                         id: resultText

                         text: r_manager.summary
                    }

                }
            }
        }
    }
}