import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.0
import QtQml.Models 2.2

import '..'

SplitView {
    property string name: 'Regression'
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
                            reg_table_model.load_data(fileDialog.fileUrl)
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
                            r_manager.get_df(reg_table_model.get_data())
                            r_manager.run_regression()
                        }
                    }
                    CheckBox {
                        id: sesonalityMonthCheckbox
                        text: qsTr("Include monthly sesonality")
                        onCheckedChanged: () => {
                            r_manager.sesonality_month = sesonalityMonthCheckbox.checkState
                        }
                    }
                    CheckBox {
                        id: sesonalityYearCheckbox
                        text: qsTr("Include yearly sesonality")
                        onCheckedChanged: () => {
                            r_manager.sesonality_year = sesonalityYearCheckbox.checkState
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
                    RegressionSettingsTable {}
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
                    ScrollView {
                        id: view
                        anchors.fill: parent
                        TextArea {
                             id: resultText
                             anchors.fill: parent
                             readOnly: true
                             color: '#aaaaaa'
                             text: r_manager.summary
                        }
                    }
                }
            }
        }
    }
}