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
            id: groupBox
            title: 'Data'
            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                Label {
                    text: 'Insert data'
                    Layout.alignment: Qt.AlignHCenter
                }
                Button {
                    text: "Ok"
                    onClicked: fileDialog.open()
                }
                Label {
                    id: fileLabel
                    text: r_manager.coeff
                    Layout.alignment: Qt.AlignHCenter
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
            }
        }
        GroupBox {
            id: groupBox2
            title: 'Data'
            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                Label {
                    id: regLabel
                    text: 'Insert data'
                    Layout.alignment: Qt.AlignHCenter
                }
                RoundButton {
                    id: startButton2
                    icon.source: '../../../assets/images/baseline-play_arrow-24px.svg'
                    radius: 0
                    ToolTip.visible: hovered
                    ToolTip.text: 'Start Training'
                    onClicked: () => {
                        r_manager.predictions_plot()
                    }
                }
                Label {
                    text: r_manager.coeff
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
        GroupBox {
            id: groupBox3
            title: 'Regression summary'
            Layout.fillWidth: true
            Layout.fillHeight: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                TableView {
                    id: tableView

                    columnWidthProvider: function (column) { return 100; }
                    rowHeightProvider: function (column) { return 60; }
                    anchors.fill: parent
                    leftMargin: rowsHeader.implicitWidth
                    topMargin: columnsHeader.implicitHeight
                    model: table_model
                    delegate: Rectangle {
                        border.width: 1
                        Text {
                            text: display
                            anchors.fill: parent
                            anchors.margins: 10
                            color: 'black'
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
                                width: 40
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

                    ScrollIndicator.horizontal: ScrollIndicator { }
                    ScrollIndicator.vertical: ScrollIndicator { }
                }
                Text {
                     id: mytext
                     anchors.fill: parent
                     textFormat: Text.RichText
                     text: r_manager.summary
                }
            }
        }
    }
    ColumnLayout {
        GroupBox {
            id: groupBox4
            title: 'Data'
            Layout.fillWidth: true
            GridLayout {
                anchors.fill: parent
                columns: 2
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 200; height: 100

                    DelegateModel {
                        id: visualModel
                        model: ListModel {
                            ListElement { name: "Apple" }
                            ListElement { name: "Orange" }
                        }

                        groups: [
                            DelegateModelGroup { name: "selected" }
                        ]

                        delegate: Rectangle {
                            id: item
                            height: 25
                            width: 200
                            Text {
                                text: {
                                    var text = "Name: " + name
                                    if (item.DelegateModel.inSelected)
                                        text += " (" + item.DelegateModel.selectedIndex + ")"
                                    return text;
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: item.DelegateModel.inSelected = !item.DelegateModel.inSelected
                            }
                        }
                    }

                    ListView {
                        anchors.fill: parent
                        model: visualModel
                    }
                }

            }
        }
    }
}