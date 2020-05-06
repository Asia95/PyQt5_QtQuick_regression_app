import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.4

import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0
import QtQml.Models 2.14
import Qt.labs.qmlmodels 1.0

import '..'

Page {
    name: 'List'
    ColumnLayout {
        GroupBox {
            id: listBox
            title: 'Data'
            Layout.fillWidth: true
            Layout.fillHeight: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                TableView {
                    id: tableView

                    columnWidthProvider: function (column) { return 300; }
                    rowHeightProvider: function (column) { return 60; }
                    anchors.fill: parent
                    leftMargin: rowsHeader.implicitWidth + logarithmCheckbox.implicitWidth + sqrtCheckbox.implicitWidth
                    topMargin: columnsHeader.implicitHeight
                    model: table_model
                    delegate: Item {
                        Text {
                            text: display
                            anchors.fill: parent
                            anchors.margins: 10

                            color: '#aaaaaa'
                            font.pixelSize: 15
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Rectangle { // mask the headers
                        z: 3
                        color: "#222222"
                        y: tableView.contentY
                        x: tableView.contentX
                        width: tableView.leftMargin
                        height: tableView.topMargin

                        Row {
                            Column {
                                Label {
                                    width: 180
                                    height: tableView.rowHeightProvider(modelData)
                                    text: ''
                                    color: '#aaaaaa'
                                    font.pixelSize: 15
                                    padding: 10
                                    verticalAlignment: Text.AlignVCenter

                                    background: Rectangle { color: "#333333" }
                                }
                            }

                            Column {
                                Label {
                                    width: 180
                                    height: tableView.rowHeightProvider(modelData)
                                    text: 'Logarithm Effect'
                                    color: '#aaaaaa'
                                    font.pixelSize: 15
                                    padding: 10
                                    verticalAlignment: Text.AlignVCenter

                                    background: Rectangle { color: "#333333" }
                                }
                            }

                            Column {
                                Label {
                                    width: 180
                                    height: tableView.rowHeightProvider(modelData)
                                    text: 'Sqrt Effect'
                                    color: '#aaaaaa'
                                    font.pixelSize: 15
                                    padding: 10
                                    verticalAlignment: Text.AlignVCenter

                                    background: Rectangle { color: "#333333" }
                                }
                            }
                        }
                    }

                    Row {
                        id: columnsHeader
                        y: tableView.contentY
                        z: 2
                        Repeater {
                            model: tableView.columns > 0 ? tableView.columns : 1
                            Label {
                                width: tableView.columnWidthProvider(modelData)
                                height: 35
                                text: table_model.headerData(modelData, Qt.Horizontal)
                                color: '#aaaaaa'
                                font.pixelSize: 15
                                padding: 10
                                verticalAlignment: Text.AlignVCenter

                                background: Rectangle { color: "#333333" }
                            }
                        }
                    }
                    Column {
                        id: rowsHeader
                        x: tableView.contentX
                        z: 2
                        Repeater {
                            model: tableView.rows > 0 ? tableView.rows : 1
                            Label {
                                width: 180
                                height: tableView.rowHeightProvider(modelData)
                                text: table_model.headerData(modelData, Qt.Vertical)
                                color: '#aaaaaa'
                                font.pixelSize: 15
                                padding: 10
                                verticalAlignment: Text.AlignVCenter

                                background: Rectangle { color: "#333333" }
                            }
                        }
                    }
                    Column {
                        id: logarithmCheckbox
                        x: tableView.contentX + rowsHeader.implicitWidth
                        z: 2
                        Repeater {
                            model: tableView.rows > 0 ? tableView.rows : 1
                            Rectangle {
                                color: "#333333"
                                width: 180
                                height: tableView.rowHeightProvider(modelData)
                                CheckBox {
                                    id: check
                                    checked: model.check
                                    onCheckedChanged: table_model.logarithm_check(modelData)
                                }
                            }

                        }
                    }
                    Column {
                        id: sqrtCheckbox
                        x: tableView.contentX + rowsHeader.implicitWidth + logarithmCheckbox.implicitWidth
                        z: 0
                        Repeater {
                            model: tableView.rows > 0 ? tableView.rows : 1
                            Rectangle {
                                color: "#333333"
                                width: 180
                                height: tableView.rowHeightProvider(modelData)
                                CheckBox {
                                    id: check
                                    onCheckedChanged: table_model.sqrt_check(modelData)
                                }
                            }

                        }
                    }


                    ScrollIndicator.horizontal: ScrollIndicator { }
                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                Button {
                    text: "Ok"
                    onClicked: r_manager.get_df(table_model.get_data())
                }


            }
        }
    }
}