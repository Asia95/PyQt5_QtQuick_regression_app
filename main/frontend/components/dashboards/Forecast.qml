import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.0
import QtQml.Models 2.2

import '..'

SplitView {
    property string name: 'Forecast'
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
                            f_manager.load_data(fileDialog.fileUrl)
                            forecast_table_model.load_data(fileDialog.fileUrl)
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
                            f_manager.get_df(forecast_table_model.get_data())
                            f_manager.run_regression()
                        }
                    }
                    CheckBox {
                        id: sesonalityMonthCheckbox
                        text: qsTr("Include monthly sesonality")
                        onCheckedChanged: () => {
                            f_manager.sesonality_month = sesonalityMonthCheckbox.checkState
                        }
                    }
                    CheckBox {
                        id: sesonalityYearCheckbox
                        text: qsTr("Include yearly sesonality")
                        onCheckedChanged: () => {
                            f_manager.sesonality_year = sesonalityYearCheckbox.checkState
                        }
                    }
                }
            }
            GroupBox {
                id: regressionSettingsBox
                title: 'Regression settings'
                Layout.fillWidth: true
                Layout.fillHeight: true
                ForecastSettingsTable {}
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
                RowLayout {
                    anchors.fill: parent
                    TableView {
                        id: summaryTable
                        anchors.fill: parent
                        clip: true
                        columnWidthProvider: function (column) { return 100; }
                        rowHeightProvider: function (column) { return 60; }
                        leftMargin: rowsHeader2.implicitWidth
                        topMargin: columnsHeader2.implicitHeight

                        model: f_manager.summary

                        delegate: Rectangle {
                            color: "#333333"
                            border.color: "black"
                            border.width: 1
                            Text {
                                text: display
                                color: '#aaaaaa'
                                width: parent.width
                                wrapMode: Text.Wrap
                                font.pixelSize: 18
                                padding: 10
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                            }
                        }
                        Rectangle { // mask the headers
                            z: 3
                            color: "#333333"

                            y: summaryTable.contentY
                            x: summaryTable.contentX
                            width: summaryTable.leftMargin
                            height: summaryTable.topMargin
                            Row {
                                Column {

                                    Label {
                                        width: 100
                                        height: summaryTable.rowHeightProvider(modelData)
                                        text: ''
                                        color: '#aaaaaa'
                                        font.pixelSize: 15
                                        padding: 10
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        background: Rectangle { color: "#333333" }
                                    }
                                }
                            }
                        }
                        Row {
                            id: columnsHeader2
                            y: summaryTable.contentY
                            z: 2
                            Repeater {
                                model: summaryTable.columns > 0 ? summaryTable.columns : 1

                                Label {
                                    width: summaryTable.columnWidthProvider(modelData)
                                    height: summaryTable.rowHeightProvider(modelData)
                                    text: f_manager.summary.headerData(modelData, Qt.Horizontal)
                                    color: '#aaaaaa'
                                    font.pixelSize: 15
                                    padding: 10
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignHCenter

                                    background: Rectangle { color: "#333333"
                                    border.color: "black"
                            border.width: 1}
                                }

                            }
                        }
                        Column {
                            id: rowsHeader2
                            x: summaryTable.contentX
                            z: 2
                            Repeater {
                                model: summaryTable.rows > 0 ? summaryTable.rows : 1

                                Label {
                                    width: summaryTable.columnWidthProvider(modelData)
                                    height: summaryTable.rowHeightProvider(modelData)
                                    text: f_manager.summary.headerData(modelData, Qt.Vertical)
                                    wrapMode: Text.Wrap
                                    color: '#aaaaaa'
                                    font.pixelSize: 15
                                    padding: 10
                                    verticalAlignment: Text.AlignVCenter

                                    background: Rectangle { color: "#333333"
                                     border.color: "black"
                            border.width: 1}
                                }
                            }
                        }
                        ScrollIndicator.horizontal: ScrollIndicator { }
                        ScrollIndicator.vertical: ScrollIndicator { }
                    }

                }
            }
        }
    }
}