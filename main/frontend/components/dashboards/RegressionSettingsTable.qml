import QtQuick 2.12
import QtQuick.Controls 2.14

import '..'

TableView {
        id: tableView
        clip: true
        columnWidthProvider: function (column) { return 100; }
        rowHeightProvider: function (column) { return 60; }
        anchors.fill: parent
        leftMargin: rowsHeader.implicitWidth + logarithmCheckbox.implicitWidth + sqrCheckbox.implicitWidth + variableCombobox.implicitWidth + interchangeCombobox.implicitWidth
        topMargin: columnsHeader.implicitHeight
        model: reg_table_model
        delegate: Item {
            Text {
                text: display
                anchors.fill: parent
                anchors.margins: 10
                color: '#aaaaaa'
                font.pixelSize: 18
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
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
                        width: 40
                        height: tableView.rowHeightProvider(modelData)
                        text: ''
                        color: '#aaaaaa'
                        font.pixelSize: 15
                        padding: 10
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        background: Rectangle { color: "#333333" }
                    }
                }
                Column {
                    Label {
                        width: 100
                        height: tableView.rowHeightProvider(modelData)
                        text: 'Logarithm Effect'
                        color: '#aaaaaa'
                        font.pixelSize: 15
                        padding: 10
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        background: Rectangle { color: "#333333" }
                    }
                }
                Column {
                    Label {
                        width: 100
                        height: tableView.rowHeightProvider(modelData)
                        text: 'Sqrt Effect'
                        color: '#aaaaaa'
                        font.pixelSize: 15
                        padding: 10
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        background: Rectangle { color: "#333333" }
                    }
                }
                Column {
                    Label {
                        width: 100
                        height: tableView.rowHeightProvider(modelData)
                        text: 'Variable Role'
                        color: '#aaaaaa'
                        font.pixelSize: 15
                        padding: 10
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        background: Rectangle { color: "#333333" }
                    }
                }
                Column {
                    Label {
                        width: 100
                        height: tableView.rowHeightProvider(modelData)
                        text: 'Interchange'
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
            id: columnsHeader
            y: tableView.contentY
            z: 2
            Repeater {
                model: tableView.columns > 0 ? tableView.columns : 1
                Label {
                    width: tableView.columnWidthProvider(modelData)
                    height: 35
                    text: 'Variables'
                    color: '#aaaaaa'
                    font.pixelSize: 15
                    padding: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter

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
                    width: 40
                    height: tableView.rowHeightProvider(modelData)
                    text: reg_table_model.headerData(modelData, Qt.Vertical)
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
                    width: 100
                    height: tableView.rowHeightProvider(modelData)
                    CheckBox {
                        id: check
                        anchors.centerIn: parent
                        onCheckedChanged: reg_table_model.logarithm_check(modelData)
                    }
                }
            }
        }
        Column {
            id: sqrCheckbox
            x: tableView.contentX + rowsHeader.implicitWidth + logarithmCheckbox.implicitWidth
            z: 0
            Repeater {
                model: tableView.rows > 0 ? tableView.rows : 1
                Rectangle {
                    color: "#333333"
                    width: 100
                    height: tableView.rowHeightProvider(modelData)
                    CheckBox {
                        id: check
                        anchors.centerIn: parent
                        onCheckedChanged: reg_table_model.sqr_check(modelData)
                    }
                }
            }
        }
        Column {
            id: variableCombobox
            x: tableView.contentX + rowsHeader.implicitWidth + logarithmCheckbox.implicitWidth + sqrCheckbox.implicitWidth
            z: 0
            Repeater {
                model: tableView.rows > 0 ? tableView.rows : 1
                Rectangle {
                    color: "#333333"
                    width: 100
                    height: tableView.rowHeightProvider(modelData)
                    ComboBox {
                        width: 90
                        anchors.centerIn: parent
                        onActivated: reg_table_model.variable_check(modelData, currentValue)
                        model: ["", "Dependent", "Independent"]
                    }
                }
            }
        }
        Column {
            id: interchangeCombobox
            x: tableView.contentX + rowsHeader.implicitWidth + logarithmCheckbox.implicitWidth + sqrCheckbox.implicitWidth + variableCombobox.implicitWidth
            z: 0
            Repeater {
                model: tableView.rows > 0 ? tableView.rows : 1
                Rectangle {
                    color: "#333333"
                    width: 100
                    height: tableView.rowHeightProvider(modelData)
                    ComboBox {
                        width: 90
                        anchors.centerIn: parent
                        onActivated: reg_table_model.variable_interchange_check(modelData, currentValue)
                        model: reg_table_model.get_variables()
                    }
                }
            }
        }

        ScrollIndicator.horizontal: ScrollIndicator { }
        ScrollIndicator.vertical: ScrollIndicator { }
    }